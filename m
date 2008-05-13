Return-Path: <linux-kernel-owner+w=401wt.eu-S1760728AbYEMWCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728AbYEMWCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 18:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbYEMWCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 18:02:01 -0400
Received: from mail2.neteffect.com ([204.57.75.68]:3309 "EHLO
	mail2.neteffect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbYEMWB7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 18:01:59 -0400
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2008 18:01:59 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/1] infiniband/hw/nes/: avoid unnecessary memset
Date: Tue, 13 May 2008 16:46:47 -0500
Message-ID: <5E701717F2B2ED4EA60F87C8AA57B7CC080BD82B@venom2>
In-Reply-To: <20080512213601.626C91C0008F@mwinf2103.orange.fr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] infiniband/hw/nes/: avoid unnecessary memset
thread-index: Aci0eC8BRa8r0rbaSzS8zwc+RE8DxAAyk3cw
References: <20080512213601.626C91C0008F@mwinf2103.orange.fr>
From: "Faisal Latif" <flatif@NetEffect.com>
To: "Christophe Jaillet" <christophe.jaillet@wanadoo.fr>,
       "linux" <linux-kernel@vger.kernel.org>,
       "Nishi Gupta" <ngupta@NetEffect.com>,
       "Glenn Streiff" <gstreiff@NetEffect.com>,
       <general@lists.openfabrics.org>
Cc: "Roland Dreier" <rdreier@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by Faisal Latif<faisal@neteffect.com>

Thanks
Faisal


> 
> From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
> 
> Hi, here is a patch against linux/drivers/infiniband/hw/nes/nes_cm.c
> which :
> 
> 1) Remove an explicit memset(.., 0, ...) to a variable allocated with
> kzalloc (i.e. 'listener').
> 
> 
> Note: this patch is based on 'linux-2.6.25.tar.bz2'
> 
> Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
> 
> ---
> 
> --- linux/drivers/infiniband/hw/nes/nes_cm.c	2008-04-17
> 04:49:44.000000000 +0200
> +++ linux/drivers/infiniband/hw/nes/nes_cm.c.cj	2008-05-12
> 23:31:24.000000000 +0200
> @@ -1587,7 +1587,6 @@ static struct nes_cm_listener *mini_cm_l
>  			return NULL;
>  		}
> 
> -		memset(listener, 0, sizeof(struct nes_cm_listener));
>  		listener->loc_addr = htonl(cm_info->loc_addr);
>  		listener->loc_port = htons(cm_info->loc_port);
>  		listener->reused_node = 0;
> 

