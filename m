Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYIYTAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYIYTAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 15:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYIYTAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 15:00:33 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:60495 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYIYTAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 15:00:33 -0400
Message-ID: <48DBDFC7.1060907@freescale.com>
Date: Thu, 25 Sep 2008 14:00:23 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: Li Yang <leoli@freescale.com>, linuxppc-dev@ozlabs.org,
       dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fsl-dma: allow Freescale Elo DMA driver to be compiled
 as a module
References: <1222293567-17694-1-git-send-email-timur@freescale.com>	 <2a27d3730809242354u4cc24b96yda3973bfc3ddac92@mail.gmail.com>	 <48DB9816.4020603@freescale.com>	 <20080925184020.GA5230@ld0162-tx32.am.freescale.net> <ed82fe3e0809251147t30743080v593d194eba731a7b@mail.gmail.com>
In-Reply-To: <ed82fe3e0809251147t30743080v593d194eba731a7b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:
> There are no dependencies.  fsldma registers with the DMA engine,
> which is always built in-kernel.  The DMA engine is what handles
> linking DMA clients to DMA drivers. The DMA clients get a callback
> whenever a DMA driver registers with the DMA engine.  If the DMA
> driver is already registered when the client registers, then the
> client will get a callback immediately after it registers.
> 
> I chose subsys_initcall() to increase the probability that fsldma is
> already present when DMA clients are loaded/initialized and register.

If there's no dependency, why does it matter whether fsldma is already 
present?

-Scott
