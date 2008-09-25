Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbYIYTJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbYIYTJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 15:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYIYTJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 15:09:34 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:37526 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbYIYTJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 15:09:33 -0400
Message-ID: <48DBE1E1.6030709@freescale.com>
Date: Thu, 25 Sep 2008 14:09:21 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Li Yang <leoli@freescale.com>, linuxppc-dev@ozlabs.org,
       dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fsl-dma: allow Freescale Elo DMA driver to be compiled
 as a module
References: <1222293567-17694-1-git-send-email-timur@freescale.com>	 <2a27d3730809242354u4cc24b96yda3973bfc3ddac92@mail.gmail.com>	 <48DB9816.4020603@freescale.com>	 <20080925184020.GA5230@ld0162-tx32.am.freescale.net> <ed82fe3e0809251147t30743080v593d194eba731a7b@mail.gmail.com> <48DBDFC7.1060907@freescale.com>
In-Reply-To: <48DBDFC7.1060907@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood wrote:

>> I chose subsys_initcall() to increase the probability that fsldma is
>> already present when DMA clients are loaded/initialized and register.
> 
> If there's no dependency, why does it matter whether fsldma is already 
> present?

Re-read my explanation, please.  Technically, it doesn't *matter* in that
nothing will break, but so what?  It's nicer if the DMA driver is already
available when the client drivers load, so that they can use the DMA facilities
right away.

-- 
Timur Tabi
Linux kernel developer at Freescale
