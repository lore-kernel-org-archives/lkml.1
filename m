Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbZCCARw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbZCCARw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760118AbZCCAQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:16:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760116AbZCCAQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:16:49 -0500
Date: Mon, 2 Mar 2009 16:15:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/2] byteorder: add load/store_{endian} API
In-Reply-To: <1236038817.5756.11.camel@brick>
Message-ID: <alpine.LFD.2.00.0903021613590.3111@localhost.localdomain>
References: <1236038817.5756.11.camel@brick>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Mar 2009, Harvey Harrison wrote:
> 
> store_le16 is a new API and is added to be symmetric with the unaligned
> functions.

This seems to be expressly designed to be unsafe, in that it casts the 
thing to the right type, making it impossible for sparse to warn about 
bad byteorder use.

		Linus
