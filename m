Return-Path: <linux-kernel-owner+w=401wt.eu-S1750888AbXDHJre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750888AbXDHJre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 05:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbXDHJre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 05:47:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35272 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbXDHJrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 05:47:32 -0400
Date: Sun, 8 Apr 2007 10:47:30 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: aeb@cwi.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] partitions: Add conditionals and static inline stubs to helpers in headers
Message-ID: <20070408094730.GB29802@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"John Anthony Kazos Jr." <jakj@j-a-k-j.com>, aeb@cwi.nl,
	linux-kernel@vger.kernel.org
References: <alpine.DEB.0.83.0704072235180.27057@sigma.j-a-k-j.com> <alpine.DEB.0.83.0704072340100.27057@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.83.0704072340100.27057@sigma.j-a-k-j.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2007 at 11:40:50PM -0400, John Anthony Kazos Jr. wrote:
> +#ifdef CONFIG_ACORN_PARTITION_ICS
> +	int adfspart_check_ICS(struct parsed_partitions *state, struct block_device *bdev);
> +#else
> +	static inline int adfspart_check_ICS(struct parsed_partitions *state, struct block_device *bdev)
> +	{
> +		return 0;
> +	}
> +#endif

Please don't indent the content of #ifdef statements.  Also make sure
lines are not longer than 80 characters.

> 
