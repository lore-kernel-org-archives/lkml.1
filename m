Return-Path: <linux-kernel-owner+w=401wt.eu-S1757810AbYBIO4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810AbYBIO4Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 09:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYBIO4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 09:56:18 -0500
Received: from www.tglx.de ([62.245.132.106]:37031 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848AbYBIO4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 09:56:17 -0500
Date: Sat, 9 Feb 2008 15:56:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/5] CPA: Split static_protections into required_static_prot
 and advised_static_prot
In-Reply-To: <20080208163612.D76421B41AA@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0802091525400.3145@apollo.tec.linutronix.de>
References: <20080208536.837219990@suse.de> <20080208163612.D76421B41AA@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, Andi Kleen wrote:
> There is a big difference between NX and RO. NX absolutely has to be cleared
> or the kernel will fail while RO just can be set, but does not need to.
> And for a large page area not setting NX if there is a area below 
> it that needs it is essential, while making it ro is optional again.

No, it's not optional. Making the PMD RO will write protect all 4k
PTEs below independent of their setting. So there is the same
restriction as we have with NX.

> This is needed for a followup patch who uses requred_static_prot() for large 
> pages where it is inconvenient to check all pages. 

> No behaviour change in this patch.
> 
> [Lines > 80 characters are changed in followup patch]

ROTFL.

	tglx
