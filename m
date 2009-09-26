Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbZIZAz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbZIZAz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 20:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbZIZAz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 20:55:29 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50699 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbZIZAz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 20:55:28 -0400
X-Greylist: delayed 1149 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Sep 2009 20:55:28 EDT
Message-ID: <4ABD61FA.2040609@cs.wisc.edu>
Date: Fri, 25 Sep 2009 19:36:10 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: kxie@chelsio.com
CC: James.Bottomley@HansenPartnership.com, davem@davemloft.net,
       swise@opengridcomputing.com, divy@chelsio.com, rakesh@chelsio.com,
       linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/2 scsi-post-merge] cxgb3i: support of private MAC
 address in iSCSI
References: <200909252225.n8PMPaa4031752@localhost.localdomain>
In-Reply-To: <200909252225.n8PMPaa4031752@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kxie@chelsio.com wrote:
> [PATCH v2 2/2 scsi-post-merge] cxgb3i: private MAC address for iSCSI
> 
> From: Karen Xie <kxie@chelsio.com>
>         
> This patch updated the use of private MAC address per port in iscsi.
> 
> This patch is generated against scsi-post-merge.
>              
> Signed-off-by: Karen Xie <kxie@chelsio.com>
> --- 
>  drivers/scsi/cxgb3i/cxgb3i_offload.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.h b/drivers/scsi/cxgb3i/cxgb3i_offload.h
> index 6a1d86b..f585ece 100644
> --- a/drivers/scsi/cxgb3i/cxgb3i_offload.h
> +++ b/drivers/scsi/cxgb3i/cxgb3i_offload.h
> @@ -234,9 +234,9 @@ struct sge_opaque_hdr {
>   * get and set private ip for iscsi traffic
>   */
>  #define cxgb3i_get_private_ipv4addr(ndev) \
> -	(((struct port_info *)(netdev_priv(ndev)))->iscsi_ipv4addr)
> +	(((struct port_info *)(netdev_priv(ndev)))->iscsic.ipv4_addr)
>  #define cxgb3i_set_private_ipv4addr(ndev, addr) \
> -	(((struct port_info *)(netdev_priv(ndev)))->iscsi_ipv4addr) = addr
> +	(((struct port_info *)(netdev_priv(ndev)))->iscsic.ipv4_addr) = addr
>  

This looks ok.

Reviewed-by Mike Christie <michaelc@cs.wisc.edu>
