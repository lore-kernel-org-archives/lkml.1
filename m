Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbZF2SvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbZF2SvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZF2Su7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:50:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51527 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbZF2Su6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:50:58 -0400
Message-ID: <4A490D00.4020908@zytor.com>
Date: Mon, 29 Jun 2009 11:50:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Petr Tesarik <ptesarik@suse.cz>
CC: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Introduce a boolean "single_bit_set" function.
References: <alpine.LFD.2.00.0904231339080.13089@localhost.localdomain>	 <1243513274.3170.1.camel@nathan.suse.cz>	 <alpine.LFD.2.00.0905280830150.31093@localhost.localdomain> <1243516357.8310.4.camel@nathan.suse.cz>
In-Reply-To: <1243516357.8310.4.camel@nathan.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Tesarik wrote:
> 
> Ok, then my only concern is that the hweight* functions return the exact
> weight, which might be much less efficient if all we need is to know
> whether it's 1.
> 
> Theoretically, gcc should be able to optimize things out, but I'm not
> all that optimistic about how well it does it.
> 

I can almost guarantee it won't in this case.

	-hpa
