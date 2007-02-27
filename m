Return-Path: <linux-kernel-owner+w=401wt.eu-S1161075AbXB0JQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161075AbXB0JQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 04:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161070AbXB0JQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 04:16:56 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:47387 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161075AbXB0JQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 04:16:54 -0500
Message-ID: <45E3F6F3.7010909@garzik.org>
Date: Tue, 27 Feb 2007 04:16:35 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Linas Vepstas <linas@austin.ibm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       kou.ishizaki@toshiba.co.jp, arnd@arndb.de,
       Jens Osterkamp <jens@de.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/12]: sungem_phy: support bcm5461 phy, autoneg.
References: <20070220221314.GU923@austin.ibm.com> <20070220223050.GA28895@austin.ibm.com>
In-Reply-To: <20070220223050.GA28895@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linas Vepstas wrote:
> From: Jens Osterkamp <jens@de.ibm.com>
> 
> This version moves the medium variable to the card specific structure and
> changes the GMII_* to BCM54XX_* #defines.
> 
> This patch adds improved version of enable_fiber for both the 5421 and
> the 5461 phy. It is now possible to specify with these wether you want
> autonegotiation or not. This is needed for bladecenter switches where
> some expect autonegotiation and some dont seem to like this at all.
> Depending on this flag it sets phy->autoneg accordingly for the fiber mode.
> 
> More importantly it implements proper read_link and poll_link functions
> for both phys which can handle both copper and fiber mode by determining
> the medium first and then branching to the required functions. For fiber
> they all work fine, for copper they are not tested but return the result
> of the genmii_* function anyway which is supposed to work.
> 
> The patch moves the genmii_* functions around to avoid foreward declarations.
> 
> Signed-off-by: Jens Osterkamp <jens@de.ibm.com>
> Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
> Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
> 
> ----
>  drivers/net/sungem_phy.c |  389 ++++++++++++++++++++++++++++++-----------------
>  drivers/net/sungem_phy.h |   10 +
>  2 files changed, 263 insertions(+), 136 deletions(-)

applied 1-12




