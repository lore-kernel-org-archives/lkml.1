Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbZFEO7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbZFEO7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbZFEO72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:59:28 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:51233 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681AbZFEO71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:59:27 -0400
Message-ID: <1244213922.4a2932a272094@imp.free.fr>
Date: Fri, 05 Jun 2009 16:58:42 +0200
From: castet.matthieu@free.fr
To: Florian Fainelli <florian@openwrt.org>
Cc: matthieu castet <castet.matthieu@free.fr>, wim@iguana.be,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mips@linux-mips.org,
       Aleksandar Radovanovic <biblbroks@sezampro.rs>
Subject: Re: add bcm47xx watchdog driver
References: <4A282D98.6020004@free.fr> <200906051558.02303.florian@openwrt.org>
In-Reply-To: <200906051558.02303.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 62.210.107.40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

Quoting Florian Fainelli <florian@openwrt.org>:

>
> Your driver looks good, could you turn this into a platform device/driver
> instead ? You declare bcm47xx_wdt_platform_device which is unused and you
> also declare a MODULE_ALIAS which suggets it is one.
What's the advantage of using platform device/driver ?
Not all watchdog driver use it (for example softdog).
This seems useless in this case because the driver don't have any resource,
don't care about suspend/resume and add complexity in the code (2 registers in
module probe, ...).


Matthieu
