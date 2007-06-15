Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbXFOO6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbXFOO6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbXFOO6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:58:01 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:37398 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbXFOO6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:58:00 -0400
Date: Fri, 15 Jun 2007 10:57:40 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Arun Raghavan <arunsr@cse.iitk.ac.in>
Cc: linux-kernel@vger.kernel.org
Subject: Re: UML - Compilation problem on 2.6.22-rc4
Message-ID: <20070615145740.GA6253@c2.user-mode-linux.org>
References: <4672307B.1030008@cse.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4672307B.1030008@cse.iitk.ac.in>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 11:53:55AM +0530, Arun Raghavan wrote:
> Hello,
> I ran into some compilations problems with UML on the 2.6.22-rc4 kernel.
> The problem turns up because "paravirt.h" is included in a couple of
> headers in asm-i386 without being protected by a "#ifdef CONFIG_PARAVIRT".
> 
> I've attached a patch to fix this (i.e. UML compiles and runs fine for
> me with these changes). I don't know if this is sufficient for all cases
> though (most other uses of the #ifdef include a lengthy #else).

Thanks, I have this fixed by making an asm-um/paravirt.h instead.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
