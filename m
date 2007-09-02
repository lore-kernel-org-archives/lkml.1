Return-Path: <linux-kernel-owner+w=401wt.eu-S966042AbXIBMGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966042AbXIBMGD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 08:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964955AbXIBMFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 08:05:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53247 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677AbXIBMFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 08:05:49 -0400
Date: Sun, 2 Sep 2007 17:48:57 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Mark Hindley <mark@hindley.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, rl@hellgate.ch,
       netdev@vger.kernel.org
Subject: Re: [OOPS] 2.6.23-rc5 ? network/via-rhine [was: hang with
 CONFIG_MCYRIXIII]
In-Reply-To: <20070902113637.GA3160@hindley.org.uk>
Message-ID: <alpine.LFD.0.999.0709021737450.24993@enigma.security.iitk.ac.in>
References: <20070902110401.GB4790@hindley.org.uk>
 <20070902113637.GA3160@hindley.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 2 Sep 2007, Mark Hindley wrote:
> 
> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000025            
> [...]
> Call Trace:
>  [<c0259b1b>] tcp_rtt_estimator+0xba/0x100
> [...]
> EIP: [<c0259a57>] tcp_rto_min+0x8/0x12 SS:ESP 0068:c0341dec

Third report of this oops within past few hours :-)

You want the patch available at:

(very long URL)
http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=blobdiff;f=net/ipv4/tcp_input.c;h=bbad2cdb74b7c18c0ae742be241857b126f06890;hp=1ee72127462bf37ed5ef834ebc71111b1cf070d5;hb=5c127c58ae9bf196d787815b1bd6b0aec5aee816;hpb=88282c6ecf0dacefda6090b0289d35e8a3cc6221
