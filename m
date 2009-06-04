Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbZFDQcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbZFDQcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZFDQc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:32:26 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:40420 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZFDQcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:32:25 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Date: Thu, 4 Jun 2009 11:21:28 -0500
User-Agent: KMail/1.9.9
Cc: Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harald Welte <HaraldWelte@viatech.com>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <e9e943910906040900j6f334f29l42a9f5a57e9a1c8f@mail.gmail.com> <alpine.LFD.2.01.0906040910280.4880@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906040910280.4880@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041121.30845.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu June 4 2009, Linus Torvalds wrote:
> 
> On Thu, 4 Jun 2009, Duane Griffin wrote:
> > 
> > There have been reports of hangs on various VIA C7 machines going back
> > a year now. The version of the kernel doesn't seem to matter, but the
> > version of glibc does. Unfortunately there hasn't been much progress
> > in getting to the bottom of it.
> > 
> > See here (and other linked reports):
> > http://bugs.gentoo.org/show_bug.cgi?id=228263
> 
> Hmm. That looks like a CPU problem, but hey, it might be that the glibc 
> version thing is just coincidence, and just changes timings or whatever, 
> and the problem is in the chipsets.
> 
> So at least from that particular report it smells very much 
> non-kernel-related.
> 
> That said, even if it isn't kernel-related, it might be fixable with some 
> kernel patch that changes the setup of the CPU/chipset. But we'd need VIA 
> to help with anythign like that.
> 

That is one of my pending questions - -
(It is included as a comment at the appropriate point in my patchset.)

The VIA processors have MCR's not MTRR's - -
The C7-M processor uses "in-order retirement" not "out-of-order" - -
I think the MCR's **should not** be set for "weak ordered writes" -

_But_ until I hear the recommendation of the Silicon Growers department...

Mike

> 			Linus
> 
> 


