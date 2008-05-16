Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbYEPWwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbYEPWwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 18:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbYEPWvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 18:51:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756594AbYEPWvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 18:51:53 -0400
Date: Fri, 16 May 2008 15:51:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT pull] x86 fixes for 2.6.26
In-Reply-To: <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805161548550.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805170037180.3255@apollo.tec.linutronix.de> <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 May 2008, Linus Torvalds wrote:
> 
> This happens almost every time somebody starts using git properly: at that 
> point the rebasing no longer hides bad habits.

Side note: to see this in action, just do

	gitk linus..

on that branch tip. Or look at the shortlog output without --no-merges:

	Avi Kivity (1):
	      x86: fix crash on cpu hotplug on pat-incapable machines

	Ingo Molnar (6):
	      Merge branch 'linus' into x86/urgent
	      Merge branch 'linus' into x86/urgent
	      Merge branch 'linus' into x86/urgent
	      Merge branch 'x86/urgent' of e2:tip into x86/urgent
	      x86: remove mwait capability C-state check
	      Merge branch 'linus' into x86/urgent

	Thomas Gleixner (1):
	      x86: disable mwait for AMD family 10H/11H CPUs

where those five merges (I know, I said six, I can't count, sue me) don't 
actually seem to do anything useful as far as x86 is concerned, ie they 
have nothing to do with the work that you were actually doing.

			Linus
