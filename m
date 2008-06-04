Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbYFDFiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbYFDFiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 01:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYFDFik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 01:38:40 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40127 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYFDFii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 01:38:38 -0400
Date: Wed, 04 Jun 2008 14:27:16 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Jeff Garzik <jeff@garzik.org>, Nathan Lynch <ntl@pobox.com>
Subject: Re: [PATCH 2/2] ehea: remove dependency on MEMORY_HOTPLUG
Cc: Badari Pulavarty <pbadari@us.ibm.com>,
       Hannes Hering <hannes.hering@linux.vnet.ibm.com>, tklein@de.ibm.com,
       themann@de.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, raisch@de.ibm.com,
       ossrosch@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org,
       ossthema@de.ibm.com, Paul Mackerras <paulus@samba.org>
In-Reply-To: <4845C8D1.4080808@garzik.org>
References: <20080603223128.GD7475@localdomain> <4845C8D1.4080808@garzik.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080604142112.979F.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I'm working for memory hotplug. This patch looks good to me. 

Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>

Thanks.

> Nathan Lynch wrote:
> > Now that walk_memory_resource() is available regardless of
> > MEMORY_HOTPLUG's setting, this dependency is not needed.
> > 
> > Signed-off-by: Nathan Lynch <ntl@pobox.com>
> > ---
> >  drivers/net/Kconfig |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> > index dd0ec9e..f4182cf 100644
> > --- a/drivers/net/Kconfig
> > +++ b/drivers/net/Kconfig
> > @@ -2426,7 +2426,7 @@ config CHELSIO_T3
> >  
> >  config EHEA
> >  	tristate "eHEA Ethernet support"
> > -	depends on IBMEBUS && INET && SPARSEMEM && MEMORY_HOTPLUG
> > +	depends on IBMEBUS && INET && SPARSEMEM
> >  	select INET_LRO
> 
> ACK, please send via appropriate target for memory hotplug stuff
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Yasunori Goto 

