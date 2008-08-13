Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYHMBBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYHMBBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 21:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbYHMBA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 21:00:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40421 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbYHMBA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 21:00:58 -0400
Date: Tue, 12 Aug 2008 17:58:35 -0700
From: Greg KH <greg@kroah.com>
To: Marcin Obara <marcin_obara@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Intel Management Engine Interface
Message-ID: <20080813005835.GE22793@kroah.com>
References: <alpine.DEB.1.00.0807172021450.26825@ip-195-3-221-75.vnet.pl> <alpine.DEB.1.00.0807180742560.7868@ip-195-3-221-75.vnet.pl> <alpine.DEB.1.00.0807181938180.12442@ip-195-3-221-75.vnet.pl> <alpine.DEB.1.00.0807182122460.24146@ip-195-3-221-75.vnet.pl> <alpine.DEB.1.00.0807182229070.30162@ip-195-3-221-75.vnet.pl> <alpine.DEB.1.00.0807231958130.20791@ip-195-3-221-75.vnet.pl> <alpine.DEB.1.00.0808112115140.6724@ip-195-3-221-75.vnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0808112115140.6724@ip-195-3-221-75.vnet.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 09:23:01PM +0200, Marcin Obara wrote:
> +/* IOCTL commands */
> +#define IOCTL_HECI_GET_VERSION \
> +    _IOWR('H' , 0x0, struct heci_message_data)

This can easily be a sysfs file, why not do that instead?

