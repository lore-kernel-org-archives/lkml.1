Return-Path: <linux-kernel-owner+w=401wt.eu-S1757829AbYEMM1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829AbYEMM1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYEMM1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:27:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58696 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbYEMM1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:27:15 -0400
Date: Tue, 13 May 2008 14:27:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       travis@sgi.com, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 6/6] x86: Add checks for virtual addresses in
	__phys_addr()
Message-ID: <20080513122701.GA14973@elte.hu>
References: <20080510020947.803480649@sgi.com> <20080510021021.472932504@sgi.com> <20080510022325.GA25712@uranus.ravnborg.org> <Pine.LNX.4.64.0805091927450.32224@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0805092007110.24814@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805092007110.24814@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> We also need to address this issue with __pa expected to be a constant 
> in 32 bit code. Sigh.

hm, even with all the fixlets it breaks with:

  http://redhat.com/~mingo/misc/config-Tue_May_13_14_17_44_CEST_2008.bad

arch/x86/kernel/e820_32.c:586: error: static declaration of 'print_memory_map' follows non-static declaration
include/asm/e820.h:75: error: previous declaration of 'print_memory_map' was here

	Ingo
