Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbYFISMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbYFISMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 14:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbYFISL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 14:11:58 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63136 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752762AbYFISL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 14:11:57 -0400
Date: Mon, 9 Jun 2008 19:11:14 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: update mptable v7 - fix
In-Reply-To: <86802c440806091051j30ac4480oe6be0a7b288f772c@mail.gmail.com>
Message-ID: <Pine.LNX.4.55.0806091905250.26593@cliff.in.clinika.pl>
References: <200805041823.57198.yhlu.kernel@gmail.com> 
 <200805251600.26325.yhlu.kernel@gmail.com>  <200806011317.38622.yhlu.kernel@gmail.com>
  <200806081953.26877.yhlu.kernel@gmail.com>  <20080609101318.GA23873@elte.hu>
 <86802c440806091051j30ac4480oe6be0a7b288f772c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008, Yinghai Lu wrote:

> thanks. So X86_MPPARSE is not needed when SMP is not enabled?

 X86_MPPARSE should depend on X86_LOCAL_APIC and you can still have it
enabled while !SMP.  I think current dependencies express it quite
clearly.

  Maciej
