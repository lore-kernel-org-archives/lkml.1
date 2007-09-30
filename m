Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbXI3XHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbXI3XHx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 19:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbXI3XGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 19:06:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45771 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbXI3XGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:06:01 -0400
Date: Mon, 1 Oct 2007 00:05:57 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       axboe@kernel.dk
Subject: Re: [PATCH v2 2/6] Sysace: Use the established platform bus api
Message-ID: <20070930230557.GA17654@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Grant Likely <grant.likely@secretlab.ca>,
	linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
	paulus@samba.org, axboe@kernel.dk
References: <20070930225112.2476.49914.stgit@trillian.cg.shawcable.net> <20070930225707.2476.24080.stgit@trillian.cg.shawcable.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070930225707.2476.24080.stgit@trillian.cg.shawcable.net>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2007 at 04:57:09PM -0600, Grant Likely wrote:
> +	if ((rc = platform_driver_register(&ace_platform_driver)) != 0)
> +		goto err_plat;

	rc = platform_driver_register(&ace_platform_driver);
	if (rc)
		 goto err_plat;

please.

> +      err_plat:
> +	unregister_blkdev(ace_major, "xsysace");
> +      err_blk:

labels should be indented zero or one space, but not more.

