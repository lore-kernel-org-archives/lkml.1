Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbZCCAT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbZCCAT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbZCCATS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:19:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751698AbZCCATS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:19:18 -0500
Date: Mon, 2 Mar 2009 16:18:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/2] unaligned: add load/store_{endian}_noalign API
In-Reply-To: <1236038818.5756.12.camel@brick>
Message-ID: <alpine.LFD.2.00.0903021616440.3111@localhost.localdomain>
References: <1236038818.5756.12.camel@brick>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Mar 2009, Harvey Harrison wrote:
>
> Add a typed API with the usual argument ordering and use load/store,
> this API is also consistent with the aligned versions.

This naming is horrible. It doesn't match the normal pattern we have in 
the kernel. 

Why not just try to fix the current (well-named) "get_unaligned_le16()" 
problems, instead of introducing a new (and badly named) version of them.

So NAK on both of these.

		Linus
