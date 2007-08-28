Return-Path: <linux-kernel-owner+w=401wt.eu-S1761526AbXH1UIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761526AbXH1UIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXH1UIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:08:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58675 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbXH1UI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:08:29 -0400
Date: Tue, 28 Aug 2007 21:08:21 +0100
From: Christoph Hellwig <hch@infradead.org>
To: m.kozlowski@tuxland.pl
Cc: airlied@linux.ie, akpm@linux-foundation.org,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] drm: introduce drm_zalloc
Message-ID: <20070828200821.GA7998@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	m.kozlowski@tuxland.pl, airlied@linux.ie, akpm@linux-foundation.org,
	dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070827205750.514001000@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827205750.514001000@tuxland.pl>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 10:57:50PM +0200, m.kozlowski@tuxland.pl wrote:
> Hello,
> 
> 	As there are many places in drm code where drm_alloc + memset is used
> this patch series introduces drm_zalloc and also makes use of drm_calloc where
> needed. Most of these patches save some bytes so the benefit is a few kB saved
> (gcc 4.1.2) with patch applied. Also some small (style, etc.) things are fixed.
> This patch series does the conversion drm tree-wide. All patches were compile
> tested.

Please just convert it to plain kzalloc/kcalloc and kill these utterly useless
wrappers instead.

