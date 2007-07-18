Return-Path: <linux-kernel-owner+w=401wt.eu-S934687AbXGRWkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934687AbXGRWkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758105AbXGRWj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:39:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33163 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759667AbXGRWj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:39:57 -0400
Message-ID: <469E96B8.3010708@garzik.org>
Date: Wed, 18 Jul 2007 18:39:52 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Thomas Klein <osstklei@de.ibm.com>
CC: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <ossthema@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       netdev <netdev@vger.kernel.org>, Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Subject: Re: [PATCH] eHEA: Fix bonding support
References: <200707181734.09278.osstklei@de.ibm.com>
In-Reply-To: <200707181734.09278.osstklei@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Klein wrote:
> The driver didn't allow an interface's MAC address to be modified if the
> respective interface wasn't setup - a failing Hcall was the result. Thus
> bonding wasn't usable. The fix moves the failing Hcall which was registering
> a MAC address for the reception of BC packets in firmware from the port up
> and down functions to the port resources setup functions. Additionally the
> missing update of the last_rx member of the netdev structure was added.
> 
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>
> 
> ---
>  drivers/net/ehea/ehea.h      |    2 +-
>  drivers/net/ehea/ehea_main.c |   37 +++++++++++++++++++------------------
>  2 files changed, 20 insertions(+), 19 deletions(-)

applied


