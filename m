Return-Path: <linux-kernel-owner+w=401wt.eu-S935296AbXHHT1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935296AbXHHT1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 15:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbXHHT1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 15:27:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45979 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758593AbXHHT1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 15:27:37 -0400
Date: Wed, 8 Aug 2007 20:27:36 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: linux-kernel@vger.kernel.org, John Johansen <jjohansen@suse.de>,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: Re: [RFC 06/10] Use vfs_permission instead of file_permission in do_path_lookup
Message-ID: <20070808192736.GC28278@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
	John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
	Erez Zadok <ezk@cs.sunysb.edu>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
References: <20070808171622.632749741@suse.de> <20070808171644.161330964@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808171644.161330964@suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 07:16:28PM +0200, Andreas Gruenbacher wrote:
> Switch from file_permission() to vfs_permission() in do_path_lookup()
> by filling in the vfs_lookup in nd slightly earlier.

While this one is okay because it is part of a lookup operation.
