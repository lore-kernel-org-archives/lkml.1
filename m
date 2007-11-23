Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbXKWLnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbXKWLnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 06:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbXKWLnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 06:43:31 -0500
Received: from zakalwe.fi ([80.83.5.154]:48553 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036AbXKWLnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 06:43:31 -0500
Date: Fri, 23 Nov 2007 13:43:29 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, kune@deine-taler.de,
       johannes@sipsolutions.net
Subject: Re: [RFC] Documentation about unaligned memory access
Message-ID: <20071123114329.GG7681@zakalwe.fi>
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2007 at 12:15:53AM +0000, Daniel Drake wrote:
> Why unaligned access is bad
> ===========================
> 
> Most architectures are unable to perform unaligned memory accesses. Any
> unaligned access causes a processor exception.

"Some architectures are unable to perform unaligned memory accesses, 
either an exception is generated, or the data 
access is silently invalid. In architectures that allow unaligned 
access, natural aligned accesses are usually faster than non-aligned."

> In summary: if your code causes unaligned memory accesses to happen, your code
> will not work on some platforms, and will perform *very* badly on others.

*very* -> *slower*

> Natural alignment
> =================

Please move this definition before "Why unaligned access is bad".

Also, it would be nice to have a table of ISAs:

ISA		Need		Need
		natural		alignment
		alignment	by x
--------------------------------------------
m68k		No		2
powerpc/ppc	Yes		Word size
x86		No		No
x86_64		No		No

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
