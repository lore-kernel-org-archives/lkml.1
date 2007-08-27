Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbXH0GL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbXH0GL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 02:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbXH0GLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 02:11:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:41108 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbXH0GLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 02:11:17 -0400
Subject: Re: hugepage: Fix broken check for offset alignment in hugepage
	mappings
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Andrew Morton <akpm@osdl.org>, William Lee Irwin <wli@holomorphy.com>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070827043627.GA7306@localhost.localdomain>
References: <20070827043627.GA7306@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 08:05:40 +0200
Message-Id: <1188194740.5972.52.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 14:36 +1000, David Gibson wrote:
> This patch restores the check, removing it from
> prepare_hugepage_range() and putting it back into
> hugetlbfs_file_mmap().  I'm putting it there, rather than in the
> get_unmapped_area() path so it only needs to go in one place, than
> separately in the half-dozen or so arch-specific implementations of
> hugetlb_get_unmapped_area().

Yup, that's the right place to put it imho.

> Signed-off-by: David Gibson <david@gibson.dropbear.id.au> 

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>


