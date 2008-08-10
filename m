Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbYHJOGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbYHJOGk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 10:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYHJOGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 10:06:32 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:44463 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852AbYHJOGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 10:06:31 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Peter Zijlstra <peterz@infradead.org>, Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11278] 2.6.27-rc2: Very odd top: '5124095h kthreadd' display
Date: Mon, 11 Aug 2008 00:06:04 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <p8tt949h41ff647i9ga0fp3jhpvnllnj3t@4ax.com>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.WR.xCjnIB@albercik> <otds94lkpmrooo1s9c0he3j3pral8fmojl@4ax.com> <200808101457.26524.rjw@sisk.pl>
In-Reply-To: <200808101457.26524.rjw@sisk.pl>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug 2008 14:57:26 +0200, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

>On Sunday, 10 of August 2008, Grant Coady wrote:
>> On Sun, 10 Aug 2008 00:43:52 +0200 (CEST), "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>> 
>> >This message has been generated automatically as a part of a report
>> >of recent regressions.
>> >
>> >The following bug entry is on the current list of known regressions
>> >from 2.6.26.  Please verify if it still should be listed and let me know
>> >(either way).
>> >
>> >
>> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11278
>> >Subject		: 2.6.27-rc2: Very odd top: '5124095h kthreadd' display
>> >Submitter	: Grant Coady <grant_lkml@dodo.com.au>
>> >Date		: 2008-08-07 7:03 (3 days old)
>> >References	: http://marc.info/?l=linux-kernel&m=121809267318795&w=4
>> >
>> 
>> Patch from Peter Z. fixed it for me, so it may be removed now.
>
>Is the patch in the mainline already?

No idea.
>
>If not, can you please provide me with a link to the patch?

root@twins:/mnt/build/linux-2.6# git show 4a273f209cc95d148f79b4c96d3d03997b44ffda | patch -p1 -R
patching file kernel/sched_clock.c

Is what I have from Peter's email.  Added Peter Z. to the Cc:

Grant.
>
>Rafael

