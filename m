Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbYBQPFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbYBQPFq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 10:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329AbYBQPFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 10:05:36 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:36780 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162AbYBQPFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 10:05:35 -0500
Date: Sun, 17 Feb 2008 16:05:22 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 09/27] x86: fix section mismatch warning in setup_64.c:nearby_node
Message-ID: <20080217150522.GA12982@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org> <1203250984-11285-9-git-send-email-sam@ravnborg.org> <alpine.LFD.1.00.0802171443490.7583@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802171443490.7583@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 02:44:23PM +0100, Thomas Gleixner wrote:
> on Sun, 17 Feb 2008, Sam Ravnborg wrote:
> 
> > Fix following warnings:
> > WARNING: vmlinux.o(.text+0x1baa2): Section mismatch in reference from the function nearby_node() to the variable .cpuinit.data:apicid_to_node
> > WARNING: vmlinux.o(.text+0x1bace): Section mismatch in reference from the function nearby_node() to the variable .cpuinit.data:apicid_to_node
> > 
> > nearby_node() were only used by __cpuinit amd_detect_cmp()
> > So annotating nearby_node() __cpuinit was the trivial fix.
> 
> Applied the x86 ones.

Thanks Thomas.

	Sam
