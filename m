Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbYIMTM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbYIMTM4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 15:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYIMTMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 15:12:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59912 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbYIMTMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 15:12:48 -0400
Message-ID: <48CC10A3.6020608@garzik.org>
Date: Sat, 13 Sep 2008 15:12:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Sebastien Dugue <sebastien.dugue@bull.net>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, themann@de.ibm.com, tklein@de.ibm.com,
       raisch@de.ibm.com, jean-pierre.dion@bull.net, gilles.carry@ext.bull.net,
       tinytim@us.ibm.com
Subject: Re: [PATCH 1/2] ehea: fix phyp debugging typo
References: <1221140080-9853-1-git-send-email-sebastien.dugue@bull.net> <1221140080-9853-2-git-send-email-sebastien.dugue@bull.net>
In-Reply-To: <1221140080-9853-2-git-send-email-sebastien.dugue@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastien Dugue wrote:
>   Fix typo in ehea_h_query_ehea() which prevents building when DEBUG is on.
> 
> Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
> ---
>  drivers/net/ehea/ehea_phyp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/ehea/ehea_phyp.c b/drivers/net/ehea/ehea_phyp.c
> index 156eb63..2a33a61 100644
> --- a/drivers/net/ehea/ehea_phyp.c
> +++ b/drivers/net/ehea/ehea_phyp.c
> @@ -535,7 +535,7 @@ u64 ehea_h_query_ehea(const u64 adapter_handle, void *cb_addr)
>  				       cb_logaddr,		/* R5 */
>  				       0, 0, 0, 0, 0);		/* R6-R10 */
>  #ifdef DEBUG
> -	ehea_dmp(cb_addr, sizeof(struct hcp_query_ehea), "hcp_query_ehea");
> +	ehea_dump(cb_addr, sizeof(struct hcp_query_ehea), "hcp_query_ehea");
>  #endif
>  	return hret;

applied


