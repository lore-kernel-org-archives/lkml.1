Return-Path: <linux-kernel-owner+w=401wt.eu-S1762473AbXHFHcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762473AbXHFHcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 03:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757621AbXHFHb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 03:31:59 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:36293 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512AbXHFHb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 03:31:57 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH] lro: eHEA example how to use LRO
Date: Mon, 6 Aug 2007 09:01:51 +0200
User-Agent: KMail/1.8.2
Cc: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Andrew Gallatin <gallatin@myri.com>, Jeff Garzik <jeff@garzik.org>,
       David Miller <davem@davemloft.net>
References: <200708031441.26841.ossthema@de.ibm.com> <46B39030.7030009@intel.com>
In-Reply-To: <46B39030.7030009@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708060901.53336.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Auke,

On Friday 03 August 2007 22:29, Kok, Auke wrote:
> Jan-Bernd Themann wrote:
> > This patch shows how the generic LRO interface is used for SKB mode
> > 
> > Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>
> > 
> > ---
> >  drivers/net/Kconfig             |    1 +
> >  drivers/net/ehea/ehea.h         |    9 ++++-
> >  drivers/net/ehea/ehea_ethtool.c |   15 +++++++
> >  drivers/net/ehea/ehea_main.c    |   84 +++++++++++++++++++++++++++++++++++---
> >  4 files changed, 101 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> > index f8a602c..fec4004 100644
> > --- a/drivers/net/Kconfig
> > +++ b/drivers/net/Kconfig
> 
> <snip>
> 
> > +module_param(use_lro, int, 0);
> 
> Have you looked at my generic lro get/set patch that I posted this week? this 
> adds a useless module parameter while ethtool has all the structure already to 
> accomodate setting lro on/off.
> 

Yes, I saw your patch. Looks very good to me. I will modify our driver soon
to use ethtool instead of this module parameter.

Thanks for adding this support to the ethtool interface.

