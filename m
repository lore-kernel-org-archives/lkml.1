Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbZIHEYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbZIHEYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 00:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZIHEYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 00:24:14 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:60048 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbZIHEYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 00:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FAbI6dMZGE4/rxevA/vU3QaMdKzl6pqXF12OhT9xGZTxtg31V4pTAm8v5j40BTVMrP
         VoN3TqmaMbpY3fpJ1qPLi0jg7vr385X+ldHvSsNcgxDiu+tYaWfats5cL5GieWlkltO/
         p2LfK/Z81yaBI5Uhq1OE2iTAHygok1QJ2nYc0=
MIME-Version: 1.0
In-Reply-To: <20090908041345.GA16315@localhost>
References: <20090908093416.5a2f98b6.minchan.kim@barrios-desktop>
	 <20090908005520.GA7967@localhost> <4AA5BB3E.4050808@cn.fujitsu.com>
	 <28c262360909072110j8ef5962h7231be5c03d68da3@mail.gmail.com>
	 <20090908041345.GA16315@localhost>
Date: Tue, 8 Sep 2009 13:24:15 +0900
Message-ID: <28c262360909072124q2fdb8d64g88144e0898801ad@mail.gmail.com>
Subject: Re: [PATCH] trace bio queueing trial only when it occurs
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 8, 2009 at 1:13 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> On Tue, Sep 08, 2009 at 12:10:55PM +0800, Minchan Kim wrote:
>> On Tue, Sep 8, 2009 at 11:02 AM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>> > Wu Fengguang wrote:
>> >> Minchan,
>> >>
>> >> I tend to agree with the change, but somehow confused by blkparse(1):
>> >>
>> >>         Q -- queued   This notes *intent* to queue i/o at the given location.  No real requests exists yet.
>> >>
>> >> Li Zefan has been working on blktrace and he can tell more.
>> >>
>> >
>> > I work on ftrace-plugin blktrace and blk TRACE_EVENT, but don't know
>> > much about the old blktrace history. ;)
>> >
>> > I think the manpage says it's called before ->make_request_fn(), so
>> > "No real requests exist yet".
>> >
>> > Actually the trace was called just before make_request at first:
>> >        2056a782f8e7e65fd4bfd027506b4ce1c5e9ccd4
>> >
>> > And then 2 patches added some checks between them:
>> >        5ddfe9691c91a244e8d1be597b6428fcefd58103
>> >        51fd77bd9f512ab6cc9df0733ba1caaab89eb957
>> >
>> > It seems to me it makes sense to have this patch.
>>
>> Thanks for good information.
>> Yes. It seems above 2 patches seem to break the rule.
>> Could I add your ACK?
>
> Sure, thanks!
>
> Acked-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks for careful review, Wu.



-- 
Kind regards,
Minchan Kim
