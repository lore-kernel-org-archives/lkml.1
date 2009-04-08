Return-Path: <linux-kernel-owner+w=401wt.eu-S1763857AbZDHUim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763857AbZDHUim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762502AbZDHUi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:38:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53092 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866AbZDHUi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:38:28 -0400
Date: Wed, 8 Apr 2009 16:38:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org,
       fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com,
       beckyb@kernel.crashing.org
Subject: Re: [PATCH 4/7] swiotlb: Allow arch override of
	address_needs_mapping
Message-ID: <20090408203823.GA14985@infradead.org>
References: <1239199761-22886-1-git-send-email-galak@kernel.crashing.org> <1239199761-22886-2-git-send-email-galak@kernel.crashing.org> <1239199761-22886-3-git-send-email-galak@kernel.crashing.org> <1239199761-22886-4-git-send-email-galak@kernel.crashing.org> <1239199761-22886-5-git-send-email-galak@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239199761-22886-5-git-send-email-galak@kernel.crashing.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 09:09:18AM -0500, Kumar Gala wrote:
> From: Becky Bruce <beckyb@kernel.crashing.org>
> 
> Some architectures require additional checking to determine
> if a device can dma to an address and need to provide their
> own address_needs_mapping..

Shouldn't we just move it completely to the arch?  I think that ia64 and
x86 currently use the same one is more of an accident.

