Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbXLEAU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbXLEAU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 19:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbXLEAUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 19:20:20 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:50042 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbXLEAUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 19:20:18 -0500
Date: Tue, 4 Dec 2007 19:19:45 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] x86: Unify include/asm-x86/linkage_[32|64].h
Message-ID: <20071205001945.GB10763@c2.user-mode-linux.org>
References: <1196801629.10408.26.camel@brick> <20071204213247.GA11216@elte.hu> <1196806868.10408.33.camel@brick> <20071204222717.GA25974@elte.hu> <20071204224543.GH15974@stusta.de> <1196809075.10408.42.camel@brick> <20071204231519.GI15974@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204231519.GI15974@stusta.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 12:15:19AM +0100, Adrian Bunk wrote:
> UML can't switch to the regparm(3) convention on i386 since it links 
> with userspace code, so if assembler code uses this calling convention 
> we need the C prototype of it annotated accordingly.

We're not talking about a global calling convention switch, right?
We're talking about selected functions only, in which case, the fact
that UML links against libc is irrelevant.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
