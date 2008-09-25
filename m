Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbYIYURO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbYIYURO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbYIYUQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:16:57 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:59842 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbYIYUQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:16:56 -0400
Message-ID: <48DBF1AC.9060909@freescale.com>
Date: Thu, 25 Sep 2008 15:16:44 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: Li Yang <leoli@freescale.com>, linuxppc-dev@ozlabs.org,
       dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fsl-dma: allow Freescale Elo DMA driver to be compiled
 as a module
References: <1222293567-17694-1-git-send-email-timur@freescale.com>	 <2a27d3730809242354u4cc24b96yda3973bfc3ddac92@mail.gmail.com>	 <48DB9816.4020603@freescale.com>	 <20080925184020.GA5230@ld0162-tx32.am.freescale.net> <ed82fe3e0809251147t30743080v593d194eba731a7b@mail.gmail.com> <48DBDFC7.1060907@freescale.com> <48DBE1E1.6030709@freescale.com>
In-Reply-To: <48DBE1E1.6030709@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:
> Scott Wood wrote:
> 
>>> I chose subsys_initcall() to increase the probability that fsldma is
>>> already present when DMA clients are loaded/initialized and register.
>> If there's no dependency, why does it matter whether fsldma is already 
>> present?
> 
> Re-read my explanation, please.

I read it just fine the first time.

> Technically, it doesn't *matter* in that
> nothing will break, but so what?  It's nicer if the DMA driver is already
> available when the client drivers load, so that they can use the DMA facilities
> right away.

It's not nicer to people reading the code and wondering why, or to 
people who use it as a module and execute less-well-tested code paths, 
and I doubt it's a significant addition to boot time to do things in the 
normal way.

I'm not particularly worried about the code going on strike because 
we're not being "nice" to it.

-Scott
