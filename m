Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbYGMRGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbYGMRGS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 13:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYGMRGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 13:06:09 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61457 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752704AbYGMRGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 13:06:08 -0400
Date: Sun, 13 Jul 2008 18:05:40 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too
In-Reply-To: <20080713164320.GJ1678@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.55.0807131752290.10630@cliff.in.clinika.pl>
References: <200807080141.05436.yhlu.kernel@gmail.com>
 <200807092017.51004.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com>
 <200807111841.55403.yhlu.kernel@gmail.com> <Pine.LNX.4.55.0807130241390.4128@cliff.in.clinika.pl>
 <86802c440807121845u3a51b239h95fa46cfb6f7c770@mail.gmail.com>
 <Pine.LNX.4.55.0807130246560.4128@cliff.in.clinika.pl>
 <20080713164320.GJ1678@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008, Suresh Siddha wrote:

> Maciej, Yinghai's current 32bit xapic_* supports both 4-bit apic and xapic.

 There is also the 82489DX, which our 32-bit code is meant to support, and
which is 8-bit physical, 32-bit logical, and which differs from the other
APICs slightly here and there -- please be careful about that.

> Yinghai, may be we should name them as apic_mem_* instead of xapic_*
> or any better suggestions?

 If you propose to rename the functions from apic_* to apic_mem_* to
signify memory-mapped rather then MSR access to the device (how
interestingly history repeats itself, with a design dated back to the VAX
now reappearing in the x86), then it sounds reasonable to me and you
surely have my support.

  Maciej
