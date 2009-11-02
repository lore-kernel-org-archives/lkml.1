Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbZKBWKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbZKBWKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 17:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbZKBWKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 17:10:18 -0500
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.104]:22840
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755784AbZKBWKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 17:10:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8BAP/n7kp8qNN0/2dsb2JhbAAI3C+EPAQ
X-IronPort-AV: E=Sophos;i="4.44,670,1249228800"; 
   d="scan'208";a="478650983"
Subject: Re: [PATCH 3/3 v2] at91/atmel-mci: inclusion of sd/mmc driver in
 at91sam9g45 chip and board
From: Ben Nizette <bn@niasdigital.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>, linux-arm-kernel@lists.infradead.org,
       "\"\\\"Thiago A.\\\"" =?ISO-8859-1?Q?Corr=EAa=22?= 
	<thiago.correa@gmail.com>,
       kernel@avr32linux.org, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <4AEF12B7.3040704@atmel.com>
References: <acfa557032a93e2d3186981b16f7048a5a31028a.1256314995.git.nicolas.ferre@atmel.com>
	 <20090930155557.7dae503b@hskinnemoen-d830>
	 <a3b1332815576dc4d496937b8a5ab69d36818d00.1256314995.git.nicolas.ferre@atmel.com>
	 <cd73a99e0910271243x744c956bl598fef9fd4144840@mail.gmail.com>
	 <20091028083548.38f1d80c@hskinnemoen-d830>
	 <d6cda7730910271753o54acfa04t1225de460083325f@mail.gmail.com>
	 <cd73a99e0910281253x1bb72b74p47cb5110efb0871f@mail.gmail.com>
	 <1256763057.4362.36.camel@ben-desktop>  <4AEF12B7.3040704@atmel.com>
Content-Type: text/plain
Date: Tue, 03 Nov 2009 09:10:30 +1100
Message-Id: <1257199830.4358.50.camel@ben-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-02 at 18:11 +0100, Nicolas Ferre wrote:
> Ben Nizette :
> > 
> > static inline int gpio_is_valid(int number)
> > {
> > 	/* only some non-negative numbers are valid */
> > 	return ((unsigned)number) < ARCH_NR_GPIOS;
> > }
> 
> I understand that the better way to solve this issue is to:
> - keep the AT91 way of specifying not connected pins (= 0)
> - code the gpio_is_valid() function for at91 that tests this way of
> handling not connected gpio
> 


> I see that in arch/arm/mach-at91/include/mach/gpio.h
> we include the asm-generic/gpio.h file... must I implement the full set
> of gpiolib ?



> 
> Best regards,

