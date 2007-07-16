Return-Path: <linux-kernel-owner+w=401wt.eu-S1765026AbXGPWAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765026AbXGPWAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761891AbXGPWAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:00:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37008 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371AbXGPWAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:00:05 -0400
Message-ID: <469BEA5F.5050508@garzik.org>
Date: Mon, 16 Jul 2007 17:59:59 -0400
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
Subject: Re: [PATCH 1/1] eHEA: Introducing support vor DLPAR memory add
References: <200707111632.00235.osstklei@de.ibm.com>
In-Reply-To: <200707111632.00235.osstklei@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Klein wrote:
> This patch adds support for DLPAR memory add to the eHEA driver. To detect
> whether memory was added the driver uses its own memory mapping table and
> checks for kernel addresses whether they're located in already known memory
> sections. If not the function ehea_rereg_mrs() is triggered which performs
> a rebuild of the mapping table and a re-registration of the global memory
> region.
> 
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>
> ---
> 
>  drivers/net/ehea/ehea.h      |   23 +++++--
>  drivers/net/ehea/ehea_main.c |  144 +++++++++++++++++++++++++++++++++++----
>  drivers/net/ehea/ehea_phyp.h |    3 +
>  drivers/net/ehea/ehea_qmr.c  |  156 ++++++++++++++++++++++++++++++------------
>  drivers/net/ehea/ehea_qmr.h  |   14 +++-
>  5 files changed, 275 insertions(+), 65 deletions(-)

applied


