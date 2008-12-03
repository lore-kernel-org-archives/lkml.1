Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbYLCMac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbYLCMac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYLCMaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:30:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59756 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYLCMaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:30:22 -0500
Date: Wed, 3 Dec 2008 07:30:21 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/6] integrity: Linux Integrity Module(LIM)
Message-ID: <20081203123021.GA30035@infradead.org>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com> <a9835f10cb3efd9951fa6e9fcc2e29f528ba625b.1228253618.git.zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9835f10cb3efd9951fa6e9fcc2e29f528ba625b.1228253618.git.zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 04:47:56PM -0500, Mimi Zohar wrote:
> +/*
> + * Integrity API calls:
> + *
> + * @collect_measurement:
> + *	Collect template specific measurement data.
> + *	@data contains template specific data used for collecting the
> + *	measurement.
> + * 	Return 0 if operation was successful.
> + *
> + * @appraise_measurement:
> + *	Appraise the integrity of the template specific measurement data.
> + *	@data contains template specific data used for appraising the
> + *	measurement.
> + * 	Return 0 if operation was successful.
> + *
> + * @store_measurement:
> + *	Store the template specific data.
> + *	@data contains template specific data used for storing the
> + *	measurement.
> + *
> + * @store_template:
> + *	Store the entry containing the template specific data.
> + *	@data contains template name, data length, and data.
> + *
> + * @must_measure:
> + *	Measurement decision based on an integrity policy.
> + *	@data contains template specific data used for making policy
> + * 	decision.
> + * 	Return 0 if operation was successful.
> + *
> + * @display_template:
> + *	Display template specific data.
> + *
> + */

Can you explain what all this template stuff is about?  The only method
of these ever called is display_template, and that seems to be better
implented directly as a securityfs file, without the indirection.

