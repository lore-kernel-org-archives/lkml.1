Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab0BICNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 21:13:24 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:10578 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab0BICNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 21:13:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XOpKVAtpGwatktAIYi5OJuHYbQN+j709b77Kv2QsRPd5vo6IlQ4zJbHOK8849C14P3
         Tpq22+4uNq02a+Q2hFJJp2Ey4ZCGI26ffbHlgjWULW20UiVIbxY6Yhm5JytxKBZ3X3K5
         cpupBEst8+rCkh8NLDYygY3NDRPWv08mCQMN8=
MIME-Version: 1.0
In-Reply-To: <20100208124845.f652e951.akpm@linux-foundation.org>
References: <28c262361002042258v7a7b8e87y3e376eaeb152b608@mail.gmail.com>
	 <20100208124845.f652e951.akpm@linux-foundation.org>
Date: Tue, 9 Feb 2010 10:13:21 +0800
Message-ID: <2375c9f91002081813w32a59b29l42c734cb2271324c@mail.gmail.com>
Subject: Re: [BUG?] recursive locking in acpi_bus_register_driver
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>, Len Brown <lenb@kernel.org>,
       inux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 9, 2010 at 4:48 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 5 Feb 2010 15:58:07 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> Is this a known bug or my hardware is bad ?
>> I use mmotm 2010-02-03-20-09.
>>
>> I didn't have a problem in 2.6.32.
>> Unfortunately I can't test it at next week.
>> I hope this problem can be reproduced easily.
>>
>
> It would be useful if you could work out whether this bug is only in
> -mm, or is in linux-next or is in mainline, please.
>
> Probably it's in linux-next, and it might be due to driver core changes
> or acpi changes.
>

Due the convert from semphore to mutex in driver core code, I think.
This is a known issue.

> Either way, we should get this weeded out lest the offending code turns
> up in 2.6.34-rc1.

Alan Stern is working on this, the patch he provided still needs to be
discussed, I think.
