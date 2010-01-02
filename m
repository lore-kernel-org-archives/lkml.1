Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438Ab0ABDSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab0ABDSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 22:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342Ab0ABDSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 22:18:11 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:58131 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab0ABDSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 22:18:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=WYIKcA9lPTrKo7rZeXUEK47NOmpTrWvnoj6b5c6fPh4Fuc/Yhaf7DwCJ8rsyJJZw3/
         jCn43JjR1ItGCn0K/VTQEkcTW/QzR+RR1e6QBC6kxZJd0zfUjNFgd7j38AonEkvtIG6l
         TCbFsWe8PeoIUECKHzkLlejRkJR+OcDhnJsUE=
MIME-Version: 1.0
In-Reply-To: <200912302239.28792.rjw@sisk.pl>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.Zg.inhOLB@chimera> 
	<20091230111745.GC4489@kernel.dk> <200912302239.28792.rjw@sisk.pl>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 1 Jan 2010 22:17:48 -0500
X-Google-Sender-Auth: bd1d134e96db14aa
Message-ID: <cb0375e11001011917y6920d45dse0b507287e8538c@mail.gmail.com>
Subject: Re: [Bug #14887] suspend doesn't work on X200s
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I suspect it was fixed by this patch:

http://lkml.org/lkml/2009/12/20/88

but I can't test because the machine in question died right after I
built it a new kernel.  sigh.

I'll re-post once I get the laptop working again if there's still a problem.

--Andy

On Wed, Dec 30, 2009 at 4:39 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday 30 December 2009, Jens Axboe wrote:
>> On Tue, Dec 29 2009, Rafael J. Wysocki wrote:
>> > This message has been generated automatically as a part of a report
>> > of recent regressions.
>> >
>> > The following bug entry is on the current list of known regressions
>> > from 2.6.32.  Please verify if it still should be listed and let me know
>> > (either way).
>> >
>> >
>> > Bug-Entry   : http://bugzilla.kernel.org/show_bug.cgi?id=14887
>> > Subject             : suspend doesn't work on X200s
>> > Submitter   : Andrew Lutomirski <luto@mit.edu>
>> > Date                : 2009-12-22 0:45 (8 days old)
>> > References  : http://marc.info/?l=linux-kernel&m=126144274102396&w=4
>>
>> Works fine for me on an x200s. The only issue I seem to have is that
>> sometimes it suspends immediately upon resume again, presumably the lid
>> close event is re-triggered (or something to that extent). Apart from
>> that, 2.6.32 and current -git works fine for me.
>
> Thanks for the info.
>
> Perhaps the bug that Andrew saw has been fixed since then.
>
> I'm changing the stauts of the bug to "resolved".  Andrew, please reopen if
> you're still seeing the problem with the current Linus' tree.
>
> Rafael
>
