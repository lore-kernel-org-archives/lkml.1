Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbYDMOhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbYDMOhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 10:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYDMOh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 10:37:27 -0400
Received: from www.tglx.de ([62.245.132.106]:60805 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbYDMOh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 10:37:27 -0400
Date: Sun, 13 Apr 2008 16:37:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Laurent GUERBY <laurent@guerby.net>
cc: linux-kernel@vger.kernel.org, Peter Oruba <peter.oruba@amd.com>
Subject: Re: BUG: soft lockup detected on Phenom with Debian 2.6.24-4
In-Reply-To: <1207985304.15628.415.camel@localhost>
Message-ID: <alpine.LFD.1.10.0804131635500.3261@apollo.tec.linutronix.de>
References: <1205013615.15075.409.camel@localhost>  <1205678588.15075.563.camel@localhost>  <1206015619.15075.666.camel@localhost>  <47E26A5D.40401@amd.com>  <1206123836.15075.699.camel@localhost> <1207985304.15628.415.camel@localhost>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008, Laurent GUERBY wrote:
> Hi,
> 
> FYI with Peter off-list help we found a way to make the ASUS M2A-VM with
> 1604 BIOS stable under my stress test: we just needed nmi_watchdog=1 in
> the kernel boot options (no other boot option necessary).

hmm, nmi_watchdog=1 disables the local apic timer. Can you add
"noapictimer" to the kernel command line instead ?

Thanks,
	tglx
