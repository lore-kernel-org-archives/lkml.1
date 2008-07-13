Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbYGMSqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbYGMSqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 14:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYGMSqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 14:46:01 -0400
Received: from smtp01.uc3m.es ([163.117.176.131]:48405 "EHLO smtp01.uc3m.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbYGMSqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 14:46:00 -0400
Date: Sun, 13 Jul 2008 20:45:53 +0200
Message-Id: <200807131845.m6DIjrX03598@inv.it.uc3m.es>
From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: fix delayed signals
X-Newsgroups: gmane.linux.kernel
In-Reply-To: <alpine.LFD.1.10.0807131121430.2959@woody.linux-foundation.org>
User-Agent: tin/1.4.4-20000803 ("Vet for the Insane") (UNIX) (Linux/2.2.15 
	(i686))
X-imss-version: 2.051
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-11.6970 TC:1F TRN:24 TV:5.5.1026(16030.001)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <alpine.LFD.1.10.0807131121430.2959@woody.linux-foundation.org> you wrote:
> Anyway, I misunderstood Edwins idea to actually throw away the writes if 
> the file isn't linked anywhere and is only open for writing. I guess we 

I don't understand it.  The process can still clone itself and its
children may want to look at what it has written (maybe there's too much
file to fit in an mmap all at once) via the same file descriptor.  Come
to that, the process itself may want to look at what it's written!

Saving memory is the idea behind writing to disk sometimes. Unlinking
your target is sensible if you want to keep your thoughts private ..

Peter
