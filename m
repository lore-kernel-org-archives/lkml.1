Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbYHXJle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbYHXJle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbYHXJl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:41:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:55826 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbYHXJlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:41:25 -0400
Subject: Re: [PATCH 1 of 3] add phys_addr_t for holding physical addresses
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, ehabkost@redhat.com,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
In-Reply-To: <73196c9129c7298f2428.1219176170@localhost>
References: <73196c9129c7298f2428.1219176170@localhost>
Content-Type: text/plain
Date: Sun, 24 Aug 2008 19:39:58 +1000
Message-Id: <1219570798.21386.213.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 .../...

> diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
> --- a/include/asm-x86/page_32.h
> +++ b/include/asm-x86/page_32.h
> @@ -33,7 +33,6 @@
>  typedef u64	pudval_t;
>  typedef u64	pgdval_t;
>  typedef u64	pgprotval_t;
> -typedef u64	phys_addr_t;
 
 .../...

Might sound a stupid question, but why have a CONFIG_ option and
a global definition based on it rather than each arch defining it
as part of the base types ? I don't have a firm preference for one
or the other at this point, I can see pro and cons to both approach,
so I'm curious to see what others think about it.

Cheers,
Ben.


