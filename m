Return-Path: <linux-kernel-owner+w=401wt.eu-S1760140AbZE1MVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140AbZE1MVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbZE1MVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:21:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54071 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756927AbZE1MVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:21:14 -0400
Subject: Re: [PATCH] Introduce a boolean "single_bit_set" function.
From: Petr Tesarik <ptesarik@suse.cz>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <alpine.LFD.2.00.0904231339080.13089@localhost.localdomain>
References: <alpine.LFD.2.00.0904231339080.13089@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Thu, 28 May 2009 14:21:14 +0200
Message-Id: <1243513274.3170.1.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day píše v Čt 23. 04. 2009 v 13:43 -0400: 
> A boolean single_bit_set() routine would simplify the numerous
> constructs of the form (((n & (n - 1)) == 0)) when testing for
> single-bitness.
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> ---
> 
> This is similar to the current is_power_of_2() routine defined in
> include/linux/log2.h, which is mathematically identical but,
> semantically, should be defined independently just so the code is more
> readable.
> 
> I'm open to an alternative function name.

ispow2() ?

Because what it really does is to check that a value is a power of two,
doesn'it.

Regards,
Petr Tesarik

P.S. aka I want my bikeshed mathematical!

