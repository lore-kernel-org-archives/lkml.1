Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbZFMFv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbZFMFv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 01:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZFMFvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 01:51:18 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:63596 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbZFMFvR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 01:51:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WdWZHvGD9P03J55/n15Dyedu+KN4aPKwjXEabwpI57ZEu/316SFupOAkxg/Pfn8CdJ
         MwyzKTXIvd32mPnjQ09COHn4w3OQvsCxurECZplC4tY8qwRcqt1VPGmo1vjmS65fqfAk
         gjttNqWqssCAk1vl84bKN/+ewqvYvcxMGftOs=
MIME-Version: 1.0
In-Reply-To: <20090612212414.1ae5a284@infradead.org>
References: <9b1675090904041103v477913a5of06fa5c10ebee05f@mail.gmail.com>
	 <9b1675090904042117k77463227y66a872d52d027e7e@mail.gmail.com>
	 <9b1675090904042125g708076e6v665f5ecc7fa020a4@mail.gmail.com>
	 <9b1675090904042313rb8178b6v1da3aeddfa57a869@mail.gmail.com>
	 <20090405062626.GA7760@mit.edu>
	 <9b1675090904051542o42a0ca11y1ce3b691ed6d8ebb@mail.gmail.com>
	 <9b1675090906062014h2ce44d8apc50f73aa036d9139@mail.gmail.com>
	 <20090611191152.GD16787@mit.edu>
	 <9b1675090906122048o35698c09x13cc7cf7650ac9ae@mail.gmail.com>
	 <20090612212414.1ae5a284@infradead.org>
Date: Fri, 12 Jun 2009 23:51:19 -0600
Message-ID: <9b1675090906122251y43476b23wd3593927e3b792c2@mail.gmail.com>
Subject: Re: IO latency - a special case
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 10:24 PM, Arjan van de Ven<arjan@infradead.org> wrote:
> On Fri, 12 Jun 2009 21:48:41 -0600
> "Trenton D. Adams" <trenton.d.adams@gmail.com> wrote:
>
>> Sorry I didn't reply earlier.  I got busy with some server troubles
>> and such.
>> > What sort of process where you typicalling trying to kill using ^C?
>>
>> It's maven, which spawns javac (java compiler), as well as does
>> various other tasks such as making connections to the Internet, local
>> directories, etc.
>
> I assume you know latencytop and how it might be useful to diagnose
> such delays ?

Your assumption would be incorrect. ;)  Never heard of it before now.
But, I did have it installed for some reason.

However, when this starts happening, it's dang near impossible to do
anything on the machine.  I wouldn't be able to run it if I tried,
though I will try :D.  I barely have enough time to Ctrl-C before the
machines locks for about 3600 seconds.  And during that time (around
10-30 seconds), I can't really switch applications, as the latency is
so high.

Right now, just during normal system usage, it's showing...
Cause                                                Maximum     Percentage
poll_schedule_timeout do_sys_poll sys_poll sysente  5.0 msec         58.0 %
futex_wait do_futex compat_sys_futex sysenter_disp  5.0 msec         40.3 %
blk_execute_rq scsi_execute scsi_execute_req scsi_  3.9 msec          0.2 %
blk_execute_rq scsi_execute scsi_execute_req sd_re  3.5 msec          0.2 %
poll_schedule_timeout do_select core_sys_select sy  3.4 msec          0.3 %
blk_execute_rq scsi_execute scsi_execute_req sr_te  2.6 msec          0.5 %
blk_execute_rq scsi_execute scsi_execute_req sr_te  2.2 msec          0.5 %
blk_execute_rq scsi_execute sr_do_ioctl sr_packet   0.9 msec          0.1 %
blk_execute_rq scsi_execute scsi_execute_req ioctl  0.6 msec          0.0 %
release __blkdev_put blkdev_put blkdev_close __fput
