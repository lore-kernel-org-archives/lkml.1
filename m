Return-Path: <linux-kernel-owner+w=401wt.eu-S1751746AbYGaKyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbYGaKyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbYGaKya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:54:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38813 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbYGaKy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:54:29 -0400
Subject: Re: [patch 3/4] Configure out ethtool support
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: bhutchings@solarflare.com, thomas.petazzoni@free-electrons.com,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, mpm@selenic.com, jgarzik@pobox.com,
       netdev@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20080731.034904.190066778.davem@davemloft.net>
References: <20080731092703.661994657@free-electrons.com>
	 <20080731093221.236840420@free-electrons.com>
	 <20080731104004.GN10471@solarflare.com>
	 <20080731.034904.190066778.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 11:54:24 +0100
Message-Id: <1217501664.3454.151.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-31 at 03:49 -0700, David Miller wrote:
> From: Ben Hutchings <bhutchings@solarflare.com>
> Date: Thu, 31 Jul 2008 11:40:05 +0100
> 
> > You also need to conditionalise dev_disable_lro().
> 
> That can only be done once the CONFIG_ETHTOOL select statement
> is added for CONFIG_INET.
> 
> Which basically makes this CONFIG_ETHTOOL thing completely pointless.

Other potential approaches include not enabling LRO by default if 
!CONFIG_ETHTOOL. Or having the driver(s) which _do_ enable LRO by
default 'select ETHTOOL'.

-- 
dwmw2

