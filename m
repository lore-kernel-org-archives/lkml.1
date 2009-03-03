Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbZCCBwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbZCCBwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 20:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbZCCBvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 20:51:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754520AbZCCBvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 20:51:50 -0500
Date: Mon, 2 Mar 2009 17:51:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/2] byteorder: add load/store_{endian} API
In-Reply-To: <1236040845.5756.33.camel@brick>
Message-ID: <alpine.LFD.2.00.0903021749030.3111@localhost.localdomain>
References: <1236038817.5756.11.camel@brick>  <alpine.LFD.2.00.0903021613590.3111@localhost.localdomain>  <1236039944.5756.19.camel@brick>  <alpine.LFD.2.00.0903021632320.3111@localhost.localdomain> <1236040845.5756.33.camel@brick>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Mar 2009, Harvey Harrison wrote:
> 
> OK, static inline it is then. Would you be opposed to an API like:
> 
> get_le16
> put_le16
> 
> to match with 
>
> get_unaligned_le16
> put_unaligned_le16
> 
> And make the existing unaligned helpers typesafe?

That sounds much better to me. That said, I'm also wondering what the 
upside is of this all?

		Linus
