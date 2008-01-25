Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbYAYD7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbYAYD7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 22:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYAYD7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 22:59:05 -0500
Received: from az33egw01.freescale.net ([192.88.158.102]:50526 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbYAYD7B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 22:59:01 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH UCC TDM 3/3 ] Modified Documentation to explain dtsentries for TDM driver
Date: Fri, 25 Jan 2008 09:28:19 +0530
Message-ID: <FBA61160C48B8D438F3323FEFB4EF2C279AFF5@zin33exm24.fsl.freescale.net>
In-Reply-To: <20080124201226.GA3926@loki.buserror.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH UCC TDM 3/3 ] Modified Documentation to explain dtsentries for TDM driver
Thread-Index: AchexWsjHuEbItgTSs+HjiksO0mNFwAQJVEg
References: <Pine.LNX.4.64.0801241022070.27491@linux121> <20080124201226.GA3926@loki.buserror.net>
From: "Aggrwal Poonam" <Poonam.Aggrwal@freescale.com>
To: "Wood Scott" <scottwood@freescale.com>
Cc: "Gala Kumar" <kumar.gala@freescale.com>, <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
       <rubini@vision.unipv.it>, <linuxppc-dev@ozlabs.org>,
       "Barkowski Michael" <Michael.Barkowski@freescale.com>,
       "Cutler Richard" <Rich.Cutler@freescale.com>,
       "Tabi Timur" <timur@freescale.com>,
       "Kalra Ashish" <ashish.kalra@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott

The device tree already has a brg-frequency  property in qe node which
is the value of BRGCLK. The function get_brg_clk uses this property to
find the value of BRGCLK.
In case this value is 0(some older u-boots populate bus-frequency
property of qe and not the brg-frequency), get_brg_clk  uses
bus-frequency/2 as BRGCLK.


With Regards
Poonam 
 
 

-----Original Message-----
From: Wood Scott 
Sent: Friday, January 25, 2008 1:42 AM
To: Aggrwal Poonam
Cc: Gala Kumar; akpm@linux-foundation.org; linux-kernel@vger.kernel.org;
netdev@vger.kernel.org; rubini@vision.unipv.it; linuxppc-dev@ozlabs.org;
Barkowski Michael; Cutler Richard; Tabi Timur; Kalra Ashish
Subject: Re: [PATCH UCC TDM 3/3 ] Modified Documentation to explain
dtsentries for TDM driver

On Thu, Jan 24, 2008 at 10:24:13AM +0530, Poonam_Aggrwal-b10812 wrote:
> +  ix) Baud Rate Generator (BRG)
> +
> +  Required properties:
> +  - compatible : shpuld be "fsl,cpm-brg"
> +  - fsl,brg-sources : define the input clock for all 16 BRGs. The
input
> +    clock source could be 1 to 24 for CLK1 to CLK24. Zero means that
the
> +    particular BRG will be driven by QE clock(BRGCLK).

Should also have a clock-frequency property to specify what BRGCLK is.

-Scott
