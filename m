Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbZLNHfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbZLNHfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 02:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZLNHf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 02:35:29 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:55140 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbZLNHf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 02:35:28 -0500
X-Auth-Info: MkTFGXeHtFrc31ROsKWiqJPhlJSYMuY1R1NRZTwOX/M=
Message-ID: <4B25EA8B.1030507@grandegger.com>
Date: Mon, 14 Dec 2009 08:34:35 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: geert@linux-m68k.org, chripell@fsfe.org, urs.thuermann@volkswagen.de,
       oliver.hartkopp@volkswagen.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: CAN_MCP251X should depend on HAS_DMA
References: <alpine.DEB.2.00.0912132008100.21225@ayla.of.borg>	<4B2552C8.4090105@grandegger.com> <20091213.174020.26980813.davem@davemloft.net>
In-Reply-To: <20091213.174020.26980813.davem@davemloft.net>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Wolfgang Grandegger <wg@grandegger.com>
> Date: Sun, 13 Dec 2009 21:47:04 +0100
> 
>> DMA can be selected with the module parameter "mcp251x_enable_dma" and
>> is *off* by default. Therefore the driver does in principle not depend
>> on HAS_DMA but I'm not sure if it's worth to handle it with #idef's.
>> Christian? Any thought?
> 
> I still think it's a reasonable dependency.
> 
> You're not going to find this device on a s390 system. :-)

OK, we could change that on request.

Wolfgang.
