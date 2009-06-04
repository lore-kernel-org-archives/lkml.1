Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbZFDQNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbZFDQNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbZFDQNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:13:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751885AbZFDQNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:13:22 -0400
Date: Thu, 4 Jun 2009 09:13:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Duane Griffin <duaneg@dghda.com>
cc: "Michael S. Zick" <lkml@morethan.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harald Welte <HaraldWelte@viatech.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
In-Reply-To: <e9e943910906040900j6f334f29l42a9f5a57e9a1c8f@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0906040910280.4880@localhost.localdomain>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain>  <200906040856.10512.lkml@morethan.org>  <200906040958.46018.lkml@morethan.org>  <alpine.LFD.2.01.0906040817090.4880@localhost.localdomain>
 <e9e943910906040900j6f334f29l42a9f5a57e9a1c8f@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Jun 2009, Duane Griffin wrote:
> 
> There have been reports of hangs on various VIA C7 machines going back
> a year now. The version of the kernel doesn't seem to matter, but the
> version of glibc does. Unfortunately there hasn't been much progress
> in getting to the bottom of it.
> 
> See here (and other linked reports):
> http://bugs.gentoo.org/show_bug.cgi?id=228263

Hmm. That looks like a CPU problem, but hey, it might be that the glibc 
version thing is just coincidence, and just changes timings or whatever, 
and the problem is in the chipsets.

So at least from that particular report it smells very much 
non-kernel-related.

That said, even if it isn't kernel-related, it might be fixable with some 
kernel patch that changes the setup of the CPU/chipset. But we'd need VIA 
to help with anythign like that.

			Linus
