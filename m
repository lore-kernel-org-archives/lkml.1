Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZBAJ6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZBAJ6X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 04:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZBAJ6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 04:58:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47425
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752691AbZBAJ6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 04:58:09 -0500
Date: Sun, 01 Feb 2009 01:58:05 -0800 (PST)
Message-Id: <20090201.015805.28182673.davem@davemloft.net>
To: dwalker@fifo99.com
Cc: roel.kluin@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: variables reach -1, but 0 tested
From: David Miller <davem@davemloft.net>
In-Reply-To: <1233434112.5903.28.camel@desktop>
References: <498429AE.1080404@gmail.com>
	<1233434112.5903.28.camel@desktop>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walker <dwalker@fifo99.com>
Date: Sat, 31 Jan 2009 12:35:12 -0800

> On Sat, 2009-01-31 at 11:36 +0100, Roel Kluin wrote:
> 
> >  
> > -	while (limit--) {
> > +	while (--limit) {
> >  		val = phy_read(phy, MII_BMCR);
> >  		if (val >= 0 && (val & BMCR_RESET) == 0)
> >  			break;
> 
> It looks like these are checked for <= to 0 , are these changes strictly
> nessesary?

Agreed.

I'd like to apply these fixes to net-2.6 but I can't if there
are spurious cases in here.

I'm dropping this patch for now.
