Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbXLEASS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbXLEASS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 19:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbXLEASJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 19:18:09 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:50027 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbXLEASI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 19:18:08 -0500
Date: Tue, 4 Dec 2007 19:17:24 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] x86: Unify include/asm-x86/linkage_[32|64].h
Message-ID: <20071205001724.GA10763@c2.user-mode-linux.org>
References: <1196801629.10408.26.camel@brick> <20071204213247.GA11216@elte.hu> <1196806868.10408.33.camel@brick> <20071204222717.GA25974@elte.hu> <20071204224543.GH15974@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204224543.GH15974@stusta.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 11:45:43PM +0100, Adrian Bunk wrote:
> > the removal of FASTCALL is fine: the default (and only) compiler model 
> > for x86 (32-bit) is regparm(3), so the regparm(3) macro is equivalent to 
> > the empty one in linux/linkage.h.
> >...
> 
> But please ensure that they stay in assembler code also used by UML.

Why?  AFAIK, whatever works for x86 will also be fine for UML.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
