Return-Path: <linux-kernel-owner+w=401wt.eu-S1765009AbYD3VWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765009AbYD3VWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761263AbYD3VWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:22:43 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59579 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759902AbYD3VWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:22:43 -0400
Date: Wed, 30 Apr 2008 22:14:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: Fix overcommit overflow
Message-ID: <20080430221458.258cbc66@core>
In-Reply-To: <20080430140936.9a27facf.akpm@linux-foundation.org>
References: <20080430214241.4313e9ca@core>
	<20080430140936.9a27facf.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  	preempt_enable();
> 
> But afacit the existing atomic_long_t does exactly what you want?

We have a portable atomic_long_t .. oooh scratch that patch then...

Alan
