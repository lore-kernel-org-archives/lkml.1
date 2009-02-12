Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbZBLW4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbZBLW4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 17:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759610AbZBLW41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 17:56:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36772
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759510AbZBLW40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 17:56:26 -0500
Date: Thu, 12 Feb 2009 14:56:20 -0800 (PST)
Message-Id: <20090212.145620.268233419.davem@davemloft.net>
To: greg@kroah.com
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 9/9] staging/sxg: fix napi interface build
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090212195133.GB16214@kroah.com>
References: <20090211132256.6622afb5.randy.dunlap@oracle.com>
	<20090212195133.GB16214@kroah.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Thu, 12 Feb 2009 11:51:33 -0800

> On Wed, Feb 11, 2009 at 01:22:56PM -0800, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix staging/sxg napi interface calls:
> > 
> > drivers/staging/sxg/sxg.c:1271: error: implicit declaration of function 'netif_rx_schedule_prep'
> > linux-next-20090209/drivers/staging/sxg/sxg.c:1272: error: implicit declaration of function '__netif_rx_schedule'
> > drivers/staging/sxg/sxg.c:1325: error: implicit declaration of function 'netif_rx_complete'
> 
> As I count over 80 instances of netif_rx_complete in Linus's tree right
> now, I'm guesing this is due to a change from the netdev tree.  Which is
> fine, but I'll wait until that gets merged with Linus to apply this
> patch.

Well it means that it won't build in -next until the next merge
window.
