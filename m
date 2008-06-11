Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbYFKLM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbYFKLM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 07:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYFKLMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 07:12:19 -0400
Received: from ozlabs.org ([203.10.76.45]:41269 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbYFKLMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 07:12:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] modules: Take a shortcut for checking if an address is in a module
Date: Wed, 11 Jun 2008 21:12:08 +1000
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
References: <20080610130519.21bc66f3@infradead.org>
In-Reply-To: <20080610130519.21bc66f3@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806112112.08623.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2008 06:05:19 Arjan van de Ven wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] modules: Take a shortcut for checking if an address is in
> a module
>
> Various pieces of the kernel (lockdep, latencytop, etc) tend to store
> backtraces, sometimes at a relatively high frequency. In itself this
> isn't a big performance deal (after all you're using diagnostics features),
> but there have been some complaints from people who have over 100 modules
> loaded that this is a tad too slow.

Nothing wrong with the idea, but how about a nice arch_maybe_module_addr() 
macro rather than ifdefs in module.c?

Thanks,
Rusty.
