Return-Path: <linux-kernel-owner+w=401wt.eu-S1757810AbYGHMmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810AbYGHMmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbYGHMmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:42:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41758 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbYGHMmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:42:14 -0400
Date: Tue, 8 Jul 2008 08:42:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Tomas Winkler <tomasw@gmail.com>, rusty <rusty@rustcorp.com.au>
Subject: Re: [PATCH] CONFIG_KMOD needs to be default y
Message-ID: <20080708124208.GA6704@infradead.org>
References: <1215517771.9610.28.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215517771.9610.28.camel@johannes.berg>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 01:49:31PM +0200, Johannes Berg wrote:
> Far too many people configure their kernel without CONFIG_KMOD
> and then complain that wireless breaks, thanks to Herbert Xu for
> pointing me to this.
> 
> This patch makes CONFIG_KMOD default to "y" and adds a warning
> that people should not turn it off.

What about just killing the config option entirely?  It' basically
guarding a ~50 lines function + a sysctl variable.  I think having
modules but not CONFIG_KMOD is entirely unreasonable.

