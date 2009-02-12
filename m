Return-Path: <linux-kernel-owner+w=401wt.eu-S1760701AbZBLU32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701AbZBLU32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759191AbZBLU2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:28:36 -0500
Received: from kroah.org ([198.145.64.141]:58939 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758768AbZBLU2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:28:35 -0500
Date: Thu, 12 Feb 2009 11:51:33 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, gregkh@suse.de
Subject: Re: [PATCH 9/9] staging/sxg: fix napi interface build
Message-ID: <20090212195133.GB16214@kroah.com>
References: <20090211132256.6622afb5.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211132256.6622afb5.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 01:22:56PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix staging/sxg napi interface calls:
> 
> drivers/staging/sxg/sxg.c:1271: error: implicit declaration of function 'netif_rx_schedule_prep'
> linux-next-20090209/drivers/staging/sxg/sxg.c:1272: error: implicit declaration of function '__netif_rx_schedule'
> drivers/staging/sxg/sxg.c:1325: error: implicit declaration of function 'netif_rx_complete'

As I count over 80 instances of netif_rx_complete in Linus's tree right
now, I'm guesing this is due to a change from the netdev tree.  Which is
fine, but I'll wait until that gets merged with Linus to apply this
patch.

thanks,

greg k-h
