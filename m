Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab0BPLJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 06:09:37 -0500
Received: from mail-bw0-f213.google.com ([209.85.218.213]:37205 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab0BPLJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 06:09:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=H62wV03tvvwL43uThZiffgpJl5wlkQibfUzZVMjPTJLu/8E5p22ZNvhWrgn76GijXz
         i7x+UtY/80N8sQv6JeB6S3SlDY0bJM2Rrid1uio1DqbUT511RoDDBHGMWOwXXcYEmejf
         qD7AhuRt/gjE+rscEFX1ZUH+UhkoW+c0B2C+o=
MIME-Version: 1.0
In-Reply-To: <201002160008.51875.rjw@sisk.pl>
References: <9b2b86521001020703v23152d0cy3ba2c08df88c0a79@mail.gmail.com>
	 <9b2b86521002030314s6f84b482v8cd680be556f8a4d@mail.gmail.com>
	 <4B718F11.2010402@tuffmail.co.uk> <201002160008.51875.rjw@sisk.pl>
Date: Tue, 16 Feb 2010 11:09:32 +0000
Message-ID: <9b2b86521002160309g26d60bd2t4c19bd2294b76c28@mail.gmail.com>
Subject: Re: s2disk hang update
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mel Gorman <mel@csn.ul.ie>, hugh.dickins@tiscali.co.uk,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday 09 February 2010, Alan Jenkins wrote:
>> Perhaps I spoke too soon.  I see the same hang if I run too many
>> applications.  The first hibernation fails with "not enough swap" as
>> expected, but the second or third attempt hangs (with the same backtrace
>> as before).
>>
>> The patch definitely helps though.  Without the patch, I see a hang the
>> first time I try to hibernate with too many applications running.
>
> Well, I have an idea.
>
> Can you try to apply the appended patch in addition and see if that helps?
>
> Rafael

It doesn't seem to help.

Thanks
Alan
