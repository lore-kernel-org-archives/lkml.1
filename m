Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbXKTIFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbXKTIFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 03:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbXKTIFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 03:05:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43763
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756246AbXKTIFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 03:05:24 -0500
Date: Tue, 20 Nov 2007 00:05:23 -0800 (PST)
Message-Id: <20071120.000523.194725858.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, wli@holomorphy.com,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH 06/59] arch/sparc: Add missing "space"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1195544916.4675.117.camel@localhost>
References: <1195523331-15303-7-git-send-email-joe@perches.com>
	<20071119.234500.127324508.davem@davemloft.net>
	<1195544916.4675.117.camel@localhost>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 19 Nov 2007 23:48:36 -0800

> On Mon, 2007-11-19 at 23:45 -0800, David Miller wrote:
> > From: Joe Perches <joe@perches.com>
> > Date: Mon, 19 Nov 2007 17:47:58 -0800
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > Please check your patches, for trailing white "space".
> > Adds trailing whitespace.
> > diff:10:		prom_printf("PCIC: Error, cannot map " 
> > Adds trailing whitespace.
> > diff:19:		prom_printf("PCIC: Error, cannot map " 
> > warning: 2 lines add whitespace errors.
> > I've fixed it up this time.
> 
> It doesn't add whitespace, but it does keep the trailing
> whitespace that's already there.

I know that, you should still do sanity checks and fix these kinds of
things up because they trigger errors in my patch applying scripts and
that of many other developers.
