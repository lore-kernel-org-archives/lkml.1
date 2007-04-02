Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbXDBL3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbXDBL3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 07:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933663AbXDBL3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 07:29:15 -0400
Received: from mail.suse.de ([195.135.220.2]:49990 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbXDBL3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 07:29:14 -0400
To: Tasos Parisinos <parisino@ceid.upatras.gr>
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, indan@nul.nu
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
References: <4610D25F.7080005@ceid.upatras.gr>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Apr 2007 14:27:40 +0200
In-Reply-To: <4610D25F.7080005@ceid.upatras.gr>
Message-ID: <p73r6r3yn9f.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tasos Parisinos <parisino@ceid.upatras.gr> writes:

> From: Tasos Parisinos <t.parisinos@sciensis.com>
> 
> This patch adds module rsa.ko in the kernel (built-in or as a kernel
> module) and offers an API to do fast modular exponentiation, using the
> Montgomery algorithm, thus the exponentiation is not generic but can
> be used only when
> the modulus is odd, such as RSA public/private key pairs. This module is the
> computational core (using multiple precision integer arithmetics) and does not
> provide any means to do key management, implement padding schemas e.t.c. so the
> calling code should implement all those as needed. Signed-off-by:
> Tasos Parisinos <t.parisinos@sciensis.com>

You forgot to answer the most important question.

What would want to use RSA in the kernel and why?  

-Andi
