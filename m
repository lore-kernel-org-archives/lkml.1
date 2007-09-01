Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbXIAQ36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbXIAQ36 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 12:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbXIAQ3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 12:29:48 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4024 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513AbXIAQ3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 12:29:47 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH] skge: unbalanced parenthesis fix
Date: Sat, 1 Sep 2007 18:29:44 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
References: <200709010810.12798.m.kozlowski@tuxland.pl> <20070901135539.40557930@oldman>
In-Reply-To: <20070901135539.40557930@oldman>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709011829.44786.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 	This patch fixes unbalanced parenthesis.
> > 
> > Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> > 
> >  drivers/net/skge.h |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- linux-2.6.23-rc4-mm1-a/drivers/net/skge.h	2007-09-01 07:23:52.000000000 +0200
> > +++ linux-2.6.23-rc4-mm1-b/drivers/net/skge.h	2007-09-01 07:37:55.000000000 +0200
> > @@ -1351,7 +1351,7 @@ enum {
> >  	PHY_M_PC_EN_DET_PLUS	= 3<<8, /* Energy Detect Plus (Mode 2) */
> >  };
> > 
> > -#define PHY_M_PC_MDI_XMODE(x)	((((u16)(x)<<5) & PHY_M_PC_MDIX_MSK)
> > +#define PHY_M_PC_MDI_XMODE(x)	(((u16)(x)<<5) & PHY_M_PC_MDIX_MSK)
> > 
> >  enum {
> >  	PHY_M_PC_MAN_MDI	= 0, /* 00 = Manual MDI configuration */
> 
> Since the macro is unused, I would rather just drop it.

Ok. Here it goes:

Remove broken and unused PHY_M_PC_MDI_XMODE macro.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/net/skge.h |    2 --
 1 file changed, 2 deletions(-)

--- linux-2.6.23-rc4-mm1-a/drivers/net/skge.h	2007-09-01 07:23:52.000000000 +0200
+++ linux-2.6.23-rc4-mm1-b/drivers/net/skge.h	2007-09-01 18:25:30.000000000 +0200
@@ -1351,8 +1351,6 @@ enum {
 	PHY_M_PC_EN_DET_PLUS	= 3<<8, /* Energy Detect Plus (Mode 2) */
 };

-#define PHY_M_PC_MDI_XMODE(x)	((((u16)(x)<<5) & PHY_M_PC_MDIX_MSK)
-
 enum {
 	PHY_M_PC_MAN_MDI	= 0, /* 00 = Manual MDI configuration */
 	PHY_M_PC_MAN_MDIX	= 1, /* 01 = Manual MDIX configuration */
