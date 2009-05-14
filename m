Return-Path: <linux-kernel-owner+w=401wt.eu-S1761216AbZENN57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761216AbZENN57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZENN5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:57:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37153 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbZENN5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:57:47 -0400
Date: Thu, 14 May 2009 09:57:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Sheng Yang <sheng@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Extend test_and_set_bit() test_and_clean_bit() to
	64 bits in X86_64
Message-ID: <20090514135747.GA7926@infradead.org>
References: <1242202647-32446-1-git-send-email-sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242202647-32446-1-git-send-email-sheng@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 04:17:27PM +0800, Sheng Yang wrote:
> This fix 44/45 bit width memory can't boot up issue. The reason is
> free_bootmem_node()->mark_bootmem_node()->__free() use test_and_clean_bit() to
> clean node_bootmem_map, but for 44bits width address, the idx set bit 31 (43 -
> 12), which consider as a nagetive value for bts.

Should we really have different prototypes for these helpers on
different architectures?

