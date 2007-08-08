Return-Path: <linux-kernel-owner+w=401wt.eu-S935031AbXHHT0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935031AbXHHT0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 15:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758957AbXHHT0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 15:26:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45964 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224AbXHHT0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 15:26:38 -0400
Date: Wed, 8 Aug 2007 20:26:37 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: linux-kernel@vger.kernel.org, John Johansen <jjohansen@suse.de>,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: Re: [RFC 05/10] Use vfs_permission instead of file_permission in sys_fchdir
Message-ID: <20070808192637.GB28278@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
	John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
	Erez Zadok <ezk@cs.sunysb.edu>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
References: <20070808171622.632749741@suse.de> <20070808171644.042011544@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808171644.042011544@suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 07:16:27PM +0200, Andreas Gruenbacher wrote:
> Create a temporary vfs_lookup object, and use vfs_permission instead
> of file_permission() in sys_fchdir().

NACK for the same reason as the previous one.

