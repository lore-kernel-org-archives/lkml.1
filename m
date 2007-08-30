Return-Path: <linux-kernel-owner+w=401wt.eu-S1761062AbXH3QYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761062AbXH3QYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 12:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756292AbXH3QYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 12:24:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35339 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbXH3QYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 12:24:09 -0400
Date: Thu, 30 Aug 2007 17:24:00 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Kristian H?gsberg <krh@redhat.com>
Cc: Dave Airlie <airlied@linux.ie>, Christoph Hellwig <hch@infradead.org>,
       m.kozlowski@tuxland.pl, akpm@linux-foundation.org,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] drm: introduce drm_zalloc
Message-ID: <20070830162400.GA12108@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Kristian H?gsberg <krh@redhat.com>, Dave Airlie <airlied@linux.ie>,
	m.kozlowski@tuxland.pl, akpm@linux-foundation.org,
	dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070827205750.514001000@tuxland.pl> <20070828200821.GA7998@infradead.org> <Pine.LNX.4.64.0708282149180.15296@skynet.skynet.ie> <1188490832.7269.6.camel@hinata.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188490832.7269.6.camel@hinata.boston.redhat.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 12:20:32PM -0400, Kristian H?gsberg wrote:
> > The wrappers aren't useless the drm alloc/free passes in a memory space 
> > for debugging purposes so we can track memory abuse when developing,
> 
> Do we ever use that, though?  Having to pass in the pointer, the size
> and the area just to free memory, sure is a bitch.

Note the slab has a memory tracking feature that accounts memory to
callers of the allocator.  IF that's not enough for you please help
improving the common code instead of inventing your own.

