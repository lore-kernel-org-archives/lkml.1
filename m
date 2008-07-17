Return-Path: <linux-kernel-owner+w=401wt.eu-S932544AbYGQUX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544AbYGQUX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758745AbYGQUXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:23:17 -0400
Received: from smarthost03.mail.mbr-roch.zen.net.uk ([212.23.3.142]:51012 "EHLO
	smarthost03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757312AbYGQUXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:23:17 -0400
X-Greylist: delayed 77617 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jul 2008 16:23:16 EDT
Date: Thu, 17 Jul 2008 21:23:01 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: jie.yang@atheros.com, jeff@garzik.org, yjwei@cn.fujitsu.com,
       rdreier@cisco.com, shemminger@vyatta.com, davem@davemloft.net,
       jcliburn@gmail.com, parag.warudkar@gmail.com, w@1wt.eu,
       oliver.schuster@schweigstill.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] atl1e: Atheros L1E Gigabit Ethernet driver
Message-ID: <20080717202259.GE19302@solarflare.com>
References: <12162854952457-git-send-email-jie.yang@atheros.com> <200807172204.15342.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807172204.15342.m.kozlowski@tuxland.pl>
User-Agent: Mutt/1.4.1i
X-Originating-Smarthost03-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Kozlowski wrote:
> Hello,
> 
> > +#define SPEED_0		   0xffff
> > +#define SPEED_10           10
> > +#define SPEED_100          100
> > +#define SPEED_100          100
> 
> Small thing - double define for SPEED_100.
> 
> > +#define SPEED_1000         1000

In fact these are all duplicates of macros defined in <linux/ethtool.h>
(except SPEED_0, whatever that means).

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
