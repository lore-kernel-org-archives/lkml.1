Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbXCXPzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbXCXPzK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 11:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbXCXPzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 11:55:10 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:55495 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbXCXPzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 11:55:08 -0400
From: Nikita Danilov <nikita@clusterfs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17925.18904.820106.145029@gargle.gargle.HOWL>
Date: Sat, 24 Mar 2007 18:55:04 +0300
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: [rfc][patch] queued spinlocks (i386)
Newsgroups: gmane.linux.kernel
In-Reply-To: <20070323103243.GE11577@wotan.suse.de>
References: <20070323085910.GA11577@wotan.suse.de>
	<20070323100418.GA30740@elte.hu>
	<20070323103243.GE11577@wotan.suse.de>
X-Mailer: VM 7.17 under 21.5 (patch 17) "chayote" (+CVS-20040321) XEmacs Lucid
X-SystemSpamProbe: GOOD 0.0000621 8c11c36c52d7cd313eb66bc9ceeb27e9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin writes:
 > On Fri, Mar 23, 2007 at 11:04:18AM +0100, Ingo Molnar wrote:
 > > 
 > > * Nick Piggin <npiggin@suse.de> wrote:
 > > 
 > > > Implement queued spinlocks for i386. [...]
 > > 
 > > isnt this patented by MS? (which might not worry you SuSE/Novell guys, 
 > > but it might be a worry for the rest of the world ;-)
 > 
 > Hmm, it looks like they have implemented a system where the spinning
 > cpu sleeps on a per-CPU variable rather than the lock itself, and
 > the releasing cpu writes to that variable to wake it.  They do this
 > so that spinners don't continually perform exclusive->shared
 > transitions on the lock cacheline. They call these things queued
 > spinlocks.  They don't seem to be very patent worthy either, but

Indeed, this technique is very well known. E.g.,
http://citeseer.ist.psu.edu/anderson01sharedmemory.html has a whole
section (3. Local-spin Algorithms) on them, citing papers from the 1990
onward.

Nikita.

