Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbXGHIQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbXGHIQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 04:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXGHIPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 04:15:49 -0400
Received: from main.gmane.org ([80.91.229.2]:39368 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbXGHIPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 04:15:46 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: Off topically about Re: malicious filesystems (was Re: Re: [PATCH] Remove process freezer from suspend to RAM pathway)
Date: Sun, 8 Jul 2007 08:15:31 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnf9181q.bju.olecom@flower.upol.cz>
References: <Pine.LNX.4.44L0.0707041045150.25704-100000@netrider.rowland.org> <18060.14856.824473.325660@cargo.ozlabs.ibm.com> <200707050858.03638.oliver@neukum.org> <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu> <20070705091801.GB3084@elf.ucw.cz> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu> <20070705115400.GF3984@ucw.cz> <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu> <20070707121729.GC3111@elf.ucw.cz> <E1I7H6v-0006pf-00@dorka.pomaz.szeredi.hu> <20070707233315.GB3820@elf.ucw.cz> <E1I7R5c-0007q3-00@dorka.pomaz.szeredi.hu>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> > > We can just wait for all fuse requests to be serviced before
>> > > proceeding further with freeze, right?
>> > 
>> > Right.  Nice way to slow down or stop the suspend with an unprivileged
>> > process.  Avoiding that sort of DoS is one of the design goals of
>> > fuse.
>> 
>> So you want me to handle _malicious_ filesystems now?
>
> What I'd like, is a suspend, that works reliably, regardless of the
> state of any userspace filesystem, network servers and such.

And this must be called sleep, deep sleep or something like that. Because
preparing for sleeping takes place, sleeping itself is a process, life
requires. Waking up, staying all day fresh and active is the needed goal.

Thus, whole freeze/ice idea was dead-born, IMHO :)

WRT this, busy-loop _waiting_ that was called sleep, usleep or
nanosleep is another wrong-named concept. I imagine somebody after one
minute sleep :)
____

