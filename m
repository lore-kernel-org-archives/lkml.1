Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbXKZPJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbXKZPJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 10:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbXKZPJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 10:09:22 -0500
Received: from mail.transmode.se ([83.241.175.147]:46126 "EHLO
	tmnt04.transmode.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753640AbXKZPJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 10:09:21 -0500
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Nov 2007 10:09:20 EST
X-MimeOLE: Produced By Microsoft Exchange V6.0.6619.12
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Organization: Transmode AB
X-Mailer: Evolution 2.10.3 
In-Reply-To: <20071126142915.19642.5842.stgit@localhost.localdomain>
Content-class: urn:content-classes:message
Subject: Re: [PATCH 2/3] [POWERPC] fsl_soc: add support for gianfar forfixed-link property
Date: Mon, 26 Nov 2007 16:04:08 +0100
Message-ID: <1196089448.12625.62.camel@gentoo-jocke.transmode.se>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/3] [POWERPC] fsl_soc: add support for gianfar forfixed-link property
Thread-Index: AcgwPZhTwkT/gsDQTA2685o4Vp2NMg==
References: <20071126142906.19642.45540.stgit@localhost.localdomain> <20071126142915.19642.5842.stgit@localhost.localdomain>
From: "Joakim Tjernlund" <joakim.tjernlund@transmode.se>
To: "Vitaly Bordug" <vitb@kernel.crashing.org>
Cc: "Jeff Garzik" <jeff@garzik.org>, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Reply-To: "Joakim Tjernlund" <joakim.tjernlund@transmode.se>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-26 at 17:29 +0300, Vitaly Bordug wrote:
> fixed-link says: register new "Fixed/emulated PHY", i.e. PHY that
> not connected to the real MDIO bus.
> 
> Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> 
> ---
> 
>  Documentation/powerpc/booting-without-of.txt |    3 +
>  arch/powerpc/sysdev/fsl_soc.c                |   56 ++++++++++++++++++--------
>  2 files changed, 42 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/powerpc/booting-without-of.txt
> index e9a3cb1..cf25070 100644
> --- a/Documentation/powerpc/booting-without-of.txt
> +++ b/Documentation/powerpc/booting-without-of.txt
> @@ -1254,6 +1254,9 @@ platforms are moved over to use the flattened-device-tree model.
>        services interrupts for this device.
>      - phy-handle : The phandle for the PHY connected to this ethernet
>        controller.
> +    - fixed-link : <a b c> where a is emulated phy id - choose any,
> +      but unique to the all specified fixed-links, b is duplex - 0 half,
> +      1 full, c is link speed - d#10/d#100/d#1000.

Good work!
May I suggest adding a "d" to <a b c> where d is flow control - 0 no, 1 yes

flow control or not just popped up here today so I got a use for it.

 Jocke 


