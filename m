Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbYDDFqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbYDDFqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 01:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbYDDFqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 01:46:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59887 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482AbYDDFq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 01:46:26 -0400
Message-ID: <47F5C0AA.4000109@garzik.org>
Date: Fri, 04 Apr 2008 01:46:18 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] net: marvell.c fix sparse shadowed variable warning
References: <1207182815.5740.21.camel@brick>
In-Reply-To: <1207182815.5740.21.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> The other if blocks don't redeclare temp, remove the redeclaration in
> the final if() block.
> 
> drivers/net/phy/marvell.c:214:7: warning: symbol 'temp' shadows an earlier one
> drivers/net/phy/marvell.c:160:6: originally declared here
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/net/phy/marvell.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index 3353991..32a8503 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -211,8 +211,6 @@ static int m88e1111_config_init(struct phy_device *phydev)
>  	}
>  
>  	if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
> -		int temp;
> -

applied


