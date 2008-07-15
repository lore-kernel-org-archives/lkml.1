Return-Path: <linux-kernel-owner+w=401wt.eu-S1763001AbYGOT3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763001AbYGOT3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbYGOT3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:29:09 -0400
Received: from smtp02.uc3m.es ([163.117.176.132]:55748 "EHLO smtp02.uc3m.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187AbYGOT3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:29:08 -0400
Date: Tue, 15 Jul 2008 21:29:04 +0200
Message-Id: <200807151929.m6FJT4W14807@inv.it.uc3m.es>
From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
To: linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from 
	in-kernel, use it in more drivers.
X-Newsgroups: gmane.linux.kernel
In-Reply-To: <alpine.LFD.1.10.0807151122010.3017@woody.linux-foundation.org>
User-Agent: tin/1.4.4-20000803 ("Vet for the Insane") (UNIX) (Linux/2.2.15 
	(i686))
X-imss-version: 2.051
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-8.8770 TC:1F TRN:20 TV:5.5.1026(16034.000)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <alpine.LFD.1.10.0807151122010.3017@woody.linux-foundation.org> Linus wrote:
> Why not just install them with the module (perhaps in the module 
> directory, perhaps not), and just load them? 

I also don't get why one can't put them in a module wrapper in some OTHER
dir as

__init__ fwFOO = something_huge_made_from_a_string ;
EXPORT_SYMBOL(fwFOO);

and have the real driver module just reference fwFOO in its init sequence.
Modprobe can deal with where to look for it. No kernel source need be
tainted.

Peter
