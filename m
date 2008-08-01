Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbYHATmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbYHATmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 15:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYHATmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 15:42:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37872 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbYHATmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 15:42:04 -0400
Subject: Re: [patch 4/4] Configure out IGMP support
From: David Woodhouse <dwmw2@infradead.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       netdev@vger.kernel.org, davem@davemloft.net, akpm@linux-foundation.org
In-Reply-To: <20080731093221.565015353@free-electrons.com>
References: <20080731092703.661994657@free-electrons.com>
	 <20080731093221.565015353@free-electrons.com>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 20:41:55 +0100
Message-Id: <1217619715.3454.488.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-31 at 11:27 +0200, Thomas Petazzoni wrote:
> This patchs adds the CONFIG_IGMP option which allows to remove support
> for the Internet Group Management Protocol, used in
> multicast. Multicast is not necessarly used by applications,
> particularly on embedded devices. As this is a size-reduction option,
> it depends on CONFIG_EMBEDDED. It allows to save ~10 kilobytes of
> kernel code/data:

The config option probably lives in net/Kconfig, not init/Kconfig.

And please could you make it clear how this interacts with IP_MULTICAST?

We already have a CONFIG_IP_MULTICAST option, for which the help text
says "For more people, it's safe to say N'. And I think it defaults to
that too. What more does CONFIG_IGMP remove? It's not made clear by the
help text.

-- 
dwmw2

