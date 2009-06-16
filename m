Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbZFPKe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbZFPKe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbZFPKer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:34:47 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:33882 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbZFPKep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:34:45 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432R98dR1805Mzz1202hzzz32i6bh17ch43j)
X-WSS-ID: 0KLBUPP-03-D9Z-01
Date: Tue, 16 Jun 2009 12:34:35 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in tty ldisc and friends
Message-ID: <20090616103435.GI5139@amd.com>
References: <alpine.DEB.2.00.0906160144340.26673@gandalf.stny.rr.com> <20090616093741.0d5b36bc@lxorguk.ukuu.org.uk> <20090616085028.GA13771@elte.hu> <20090616095706.36f01282@lxorguk.ukuu.org.uk> <20090616100015.GD6432@elte.hu> <20090616110419.14bc9485@lxorguk.ukuu.org.uk> <20090616101240.GB28204@elte.hu> <20090616102509.GA32717@elte.hu> <20090616102910.GA11011@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090616102910.GA11011@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 Jun 2009 10:34:35.0769 (UTC) FILETIME=[0B270690:01C9EE6E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 12:29:10PM +0200, Ingo Molnar wrote:
> We are now well below the limit for stack-trace entries.
> 
> This is something we noticed recently: dma-debug uses a lot of lock 
> classes and thus creates a really large lock-graph, depleting the 
> reserves quickly.

Is this considered a problem? I increased the hash-size to 1024 for
performance reasons (== 1024 spin_locks). But if it hurts to much in
other places this can be reverted.

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

