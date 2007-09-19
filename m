Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbXISHME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbXISHME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 03:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbXISHLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 03:11:51 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:1783 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbXISHLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 03:11:50 -0400
X-IronPort-AV: i="4.20,271,1186372800"; 
   d="scan'208"; a="39891235:sNHT26360572"
Subject: Re: [PATCH 1/3] Blackfin EMAC driver: add function to change the
	MAC	address
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Jeff Garzik <jeff@garzik.org>
Cc: bryan.wu@analog.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <46F04C2A.20500@garzik.org>
References: <1189911423.9901.4.camel@roc-laptop> <46F04C2A.20500@garzik.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 19 Sep 2007 15:07:38 +0800
Message-Id: <1190185658.28309.0.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 19 Sep 2007 07:11:48.0772 (UTC) FILETIME=[58559E40:01C7FA8C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-19 at 06:07 +0800, Jeff Garzik wrote:
> Bryan Wu wrote: 
> >>From 157dfddae50708a716c2a42a314eccb9621d8793 Mon Sep 17 00:00:00
> 2001 
> > From: Alex Landau <lirsb@yahoo.com> 
> > Date: Sun, 5 Aug 2007 15:58:03 +0800 
> > Subject: [PATCH] Blackfin Ethernet MAC driver: add function to
> change the MAC address 
> > 
> > Alex Landau writes in the forums: 
> >   Previously, changing the MAC address (e.g. via ifconfig) resulted 
> >   in a generic function to be called that only changed a variable
> in 
> >   memory. This patch also updated the Blackfin MAC address
> registers 
> >   to filter the correct new MAC. 
> > 
> > Signed-off-by: Alex Landau <lirsb@yahoo.com> 
> > Signed-off-by: Mike Frysinger <michael.frysinger@analog.com> 
> > Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> 
> ACK patches 1-3... but can you regenerate them against 
> netdev-2.6.git#upstream (or davem/net-2.6.24.git)?

Excellent, I will resend the patch against the netdev-2.6.git#upstream
ASAP.

Thanks
-Bryan Wu
> 
