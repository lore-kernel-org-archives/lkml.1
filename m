Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbZDHWYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbZDHWYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 18:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZDHWYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 18:24:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53733 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbZDHWYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 18:24:36 -0400
Date: Wed, 8 Apr 2009 18:24:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: galak@kernel.crashing.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, jeremy@goop.org, ian.campbell@citrix.com,
       beckyb@kernel.crashing.org
Subject: Re: [PATCH 4/7] swiotlb: Allow arch override of
	address_needs_mapping
Message-ID: <20090408222431.GA20276@infradead.org>
References: <1239199761-22886-5-git-send-email-galak@kernel.crashing.org> <20090408203823.GA14985@infradead.org> <7366A4DE-6848-4AF6-AA33-6BD89B0A5153@kernel.crashing.org> <20090409061444G.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409061444G.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 06:15:07AM +0900, FUJITA Tomonori wrote:
> ia64 and x86_64 use swiotlb but neither need this function. And
> neither need any above __weak. They were added for dom0 support.
> Yeah, swiotlb is much cleaner and better if we don't add dom0 support.

Agreed.  All these dom0 support patches look like a cat has been barfing
over the source code.
