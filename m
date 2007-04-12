Return-Path: <linux-kernel-owner+w=401wt.eu-S1946065AbXDLJyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946065AbXDLJyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946095AbXDLJyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:54:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49765 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945974AbXDLJys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:54:48 -0400
Date: Thu, 12 Apr 2007 10:54:28 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Nate Diller <nate.diller@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       David Woodhouse <dwmw2@infradead.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Anton Altaparmakov <aia21@cantab.net>,
       Evgeniy Dushistov <dushistov@mail.ru>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-dev@namesys.com
Subject: Re: [PATCH 1/17] cramfs: use read_mapping_page
Message-ID: <20070412095428.GA22675@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nate Diller <nate.diller@gmail.com>, Andrew Morton <akpm@osdl.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Roman Zippel <zippel@linux-m68k.org>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	David Woodhouse <dwmw2@infradead.org>,
	Dave Kleikamp <shaggy@austin.ibm.com>,
	Anton Altaparmakov <aia21@cantab.net>,
	Evgeniy Dushistov <dushistov@mail.ru>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, reiserfs-dev@namesys.com
References: <20070412024938.27380.54538.patchbomb.py@localhost> <20070412024938.27380.87060.patchbomb.py@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412024938.27380.87060.patchbomb.py@localhost>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 07:49:38PM -0700, Nate Diller wrote:
> read_mapping_page_async() is going away, so convert its only user to
> read_mapping_page().  This change has not been benchmarked, however, in
> order to get real parallelism this wants something completely different,
> like __do_page_cache_readahead(), which is not currently exported.

Why is read_mapping_page_async going away?  This probably needs a lot more
testing, and I'd be much happier if you split it out of the series and
sent it separately at the end.

