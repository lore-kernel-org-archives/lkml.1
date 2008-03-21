Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbYCUW05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbYCUW05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbYCUW0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:26:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38255 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbYCUW0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:26:47 -0400
Date: Fri, 21 Mar 2008 15:26:35 -0700
From: Greg KH <greg@kroah.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sysfs: allow the group is_visible() method to
	return a mode and add an update API
Message-ID: <20080321222635.GA2674@kroah.com>
References: <1206134832.2961.64.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206134832.2961.64.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 04:27:12PM -0500, James Bottomley wrote:
> We have a problem in scsi_transport_spi in that we need to customise
> not only the visibility of the attributes, but also their mode.  Fix
> this by making the is_visible() callback return a mode, with 0
> indicating is not visible.
> 
> Also add a sysfs_update_group() API to allow us to change either the
> visibility or mode of the files at any time on the fly.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
> 
> Greg, can I take this through SCSI, please ... assuming it's OK?  We
> need this to fix up the SPI transport class.

Sure.  But can you document that "update" field a bit more so we can
remember what it means in the future?

thanks,

greg k-h
