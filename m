Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbYL3CTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbYL3CTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 21:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYL3CTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 21:19:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33206
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751299AbYL3CTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 21:19:05 -0500
Date: Mon, 29 Dec 2008 18:19:08 -0800 (PST)
Message-Id: <20081229.181908.214463121.davem@davemloft.net>
To: nhorman@tuxdriver.com
Cc: sfr@canb.auug.org.au, kamalesh@linux.vnet.ibm.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] clean up of netif_rx_reschedule() changes in drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081229153757.GA2857@localhost.localdomain>
References: <20081229102509.GA11111@linux.vnet.ibm.com>
	<20081229214144.43be8c1d.sfr@canb.auug.org.au>
	<20081229153757.GA2857@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 29 Dec 2008 10:37:57 -0500

> On Mon, Dec 29, 2008 at 09:41:44PM +1100, Stephen Rothwell wrote:
> > Hi Kamalesh,
> > 
> > On Mon, 29 Dec 2008 15:55:29 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> > > greping through the sources for the changes missed out, we have
> > > 
> > 	.
> > 	.
> > > 
> > > Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
 ...
> Thanks guys, not sure how my patch missed that.  I did an allmodconfig build
> that passed successfully.  Thanks!

It's very simple, you're not building on powerpc or ARM :-)

> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Applied, thanks everyone.
