Return-Path: <linux-kernel-owner+w=401wt.eu-S1760260AbXH2TJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbXH2TJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 15:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbXH2TJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 15:09:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34978 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbXH2TJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 15:09:27 -0400
Date: Wed, 29 Aug 2007 20:09:26 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: Re: [patch 3/4] Introduce pathget
Message-ID: <20070829190926.GC28028@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
	John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
	Erez Zadok <ezk@cs.sunysb.edu>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
References: <20070808171622.632749741@suse.de> <20070808171643.542685765@suse.de> <20070808193209.GA31354@infradead.org> <20070810142208.827949199@suse.de> <20070810143847.060182988@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810143847.060182988@suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 04:22:11PM +0200, Andreas Gruenbacher wrote:
> This is the symmetric operation to pathput.

The primitive looks fine to me, but it needs a kerneldoc comment describing
it.  Also I think both this and pathput should not actually be inline.

