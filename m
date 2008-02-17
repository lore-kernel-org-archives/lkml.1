Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbYBQNot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbYBQNot (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 08:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYBQNom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 08:44:42 -0500
Received: from www.tglx.de ([62.245.132.106]:60086 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbYBQNol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 08:44:41 -0500
Date: Sun, 17 Feb 2008 14:44:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 09/27] x86: fix section mismatch warning in
 setup_64.c:nearby_node
In-Reply-To: <1203250984-11285-9-git-send-email-sam@ravnborg.org>
Message-ID: <alpine.LFD.1.00.0802171443490.7583@apollo.tec.linutronix.de>
References: <20080217121255.GA10519@uranus.ravnborg.org> <1203250984-11285-9-git-send-email-sam@ravnborg.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on Sun, 17 Feb 2008, Sam Ravnborg wrote:

> Fix following warnings:
> WARNING: vmlinux.o(.text+0x1baa2): Section mismatch in reference from the function nearby_node() to the variable .cpuinit.data:apicid_to_node
> WARNING: vmlinux.o(.text+0x1bace): Section mismatch in reference from the function nearby_node() to the variable .cpuinit.data:apicid_to_node
> 
> nearby_node() were only used by __cpuinit amd_detect_cmp()
> So annotating nearby_node() __cpuinit was the trivial fix.

Applied the x86 ones.

Thanks,

	tglx
