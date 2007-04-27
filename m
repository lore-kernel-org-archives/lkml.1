Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722AbXD0Mge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbXD0Mge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbXD0Mge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:36:34 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:2874 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722AbXD0Mgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:36:33 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: suspend2-devel@lists.suspend2.net
Subject: Re: suspend2 merge
Date: Fri, 27 Apr 2007 14:36:26 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
References: <20070419070437.GA25211@elte.hu> <20070425192512.GZ3468@stusta.de> <alpine.LFD.0.98.0704251231111.9964@woody.linux-foundation.org> (sfid-20070425_233551_691811_D5D99E0D)
In-Reply-To: <alpine.LFD.0.98.0704251231111.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704271436.27353.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 25 April 2007 schrieb Linus Torvalds:

> And that's a *fundamental* problem. If the STD people cannot even
> realize that they have less to do with "suspend" than to "reboot", how
> do you ever expect them to get anything to work, and not affect other
> things negatively?
>
> Yeah, I'm down on it. I'm down on it because every person involved with
> the whole STD thing seems to have basically zero taste, and a total
> inability to work with anybody else.

Hello Linus!

I am no kernel developer. But I understand what you are trying to tell 
here.

I agree that suspend to ram and snapshot should be handled differently by 
drivers. And unlike schedulers - whether it be I/O or process related 
ones - I think it should be quite easy to settle and decide on *one* 
implementation for each feature. It least it doesn't look as difficult as 
deciding on a scheduler which works for all the different workloads to 
me.

I do not believe that the reasons preventing this to happen until now are 
of pure technical nature.

I think snapshotting is a very important feature. I would patch it into my 
kernels if it was removed. But then I am using suspend2 anyway.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
