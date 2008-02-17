Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYBQOCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYBQOCq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 09:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbYBQOCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 09:02:37 -0500
Received: from www.tglx.de ([62.245.132.106]:42529 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381AbYBQOCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 09:02:36 -0500
Date: Sun, 17 Feb 2008 15:02:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lguest: include function prototypes
In-Reply-To: <1202937275.18204.1.camel@brick>
Message-ID: <alpine.LFD.1.00.0802171501470.7583@apollo.tec.linutronix.de>
References: <1202937275.18204.1.camel@brick>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Harvey Harrison wrote:

> Fix for sparse warning
> arch/x86/lguest/boot.c:939:13: warning: symbol 'lguest_init' was not declared. Should it be static?
> 
> Added a declaration to asm-x86/lguest.h and moved the extern arrays there
> as well.  As an alternative to including asm/lguest.h directly, an
> include could be put in linux/lguest.h

Applied. Thanks,

	 tglx
