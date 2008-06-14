Return-Path: <linux-kernel-owner+w=401wt.eu-S1760155AbYFNVeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155AbYFNVeJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758243AbYFNV2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:28:21 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61604 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758864AbYFNV2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:28:20 -0400
Date: Sat, 14 Jun 2008 22:27:29 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [patch 0/6] AMD C1E aware idle support
In-Reply-To: <20080610171639.551369443@linutronix.de>
Message-ID: <Pine.LNX.4.55.0806142222040.3771@cliff.in.clinika.pl>
References: <20080610171639.551369443@linutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008, Thomas Gleixner wrote:

> @Macej: I bisected your patches and the commit which solves the mysterious
> hangs is:
> 
> x86: I/O APIC: timer through 8259A second-chance
> (7e3530cd98a0c6ab38f5898e855a5beffab26561 in linux-2.6-tip.git)
> 
> That's the patch which you worried about possible impacts, but it
> seems that it actually fixes the stupid timer irq issue finally. I
> have tested it on various machines which had timer irq problems in the
> past and they all run smothly. Great work!

 Well, I did hope at least some impact would be positive!  I am glad this 
is the case and thanks for your report as well as appreciation.

  Maciej
