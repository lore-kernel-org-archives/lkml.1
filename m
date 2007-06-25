Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbXFYVN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbXFYVN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbXFYVNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:13:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:37870 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbXFYVNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:13:20 -0400
Date: Mon, 25 Jun 2007 23:12:59 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: Petr Vandrovec <petr@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22-rc5-yesterdaygit with VM debug: BUG in mm/rmap.c:66: anon_vma_link ?
Message-ID: <20070625211259.GD7059@v2.random>
References: <467F6882.9000800@vmware.com> <Pine.LNX.4.64.0706252129430.22492@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706252129430.22492@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 10:05:09PM +0100, Hugh Dickins wrote:
> size of memory?); but I rather think validate_anon_vma has outlived its
> usefulness, and is better just removed - which gives a magnificent

Probably yes. But the most fundamental issue is that this code
probably was never meant to be enabled through a menuconfig tweak but
only by editing the source.
