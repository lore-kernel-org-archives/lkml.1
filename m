Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbZKCVF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbZKCVF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 16:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbZKCVF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 16:05:56 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38563 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbZKCVFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 16:05:55 -0500
Date: Tue, 3 Nov 2009 21:05:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>, plagnioj@jcrosoft.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       avictor.za@gmail.com
Subject: Re: [RFC PATCH] atmel_lcdfb Kconfig: remove long dependency line
Message-ID: <20091103210542.GA8719@n2100.arm.linux.org.uk>
References: <4A40D695.5000302@atmel.com> <1245767456-6434-1-git-send-email-nicolas.ferre@atmel.com> <20090623153556.0e574899@hskinnemoen-d830> <4A40E2E6.9060904@atmel.com> <20090625084631.GA7985@n2100.arm.linux.org.uk> <4AF04148.8070103@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF04148.8070103@atmel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 03:42:16PM +0100, Nicolas Ferre wrote:
> The problem is that if I do not setup the dependency here the menu entry
> will not be available at the proper level. In fact I will see the Atmel
> LCD entry here:
> "Graphics support"
>  <*> Support for frame buffer devices  --->
>  <*> AT91/AT32 LCD Controller support
> 
> instead of here:
> "Graphics support"
>  ---> "Support for frame buffer devices"
>       [..]
>       <*> "AT91/AT32 LCD Controller support"
>       [..]
> 
> So I keep the depend.

The depend is on ARCH_ATMEL_HAS_FB which has no description (and therefore
does not appear in the menus) not the symbol for "AT91/AT32 LCD Controller
support".
