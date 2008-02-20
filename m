Return-Path: <linux-kernel-owner+w=401wt.eu-S932240AbYBTW0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbYBTW0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYBTWZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:25:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59426 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758304AbYBTWZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:25:51 -0500
Date: Wed, 20 Feb 2008 14:22:48 -0800
From: Greg KH <greg@kroah.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci: remove parisc consumer of the pci global_list
Message-ID: <20080220222248.GA15308@kroah.com>
References: <1203542065.3109.42.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203542065.3109.42.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 03:14:24PM -0600, James Bottomley wrote:
> The patch  pci-remove-global-list-of-pci-devices.patch misses the parisc
> dino use of this.  However, it's a simple removal job.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

Ah, sorry about that, I'll add that to my tree in the correct order so
we don't get bisect problems.

thanks,

greg k-h
