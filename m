Return-Path: <linux-kernel-owner+w=401wt.eu-S1753034AbZEaWgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbZEaWgH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 18:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbZEaWf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 18:35:56 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:64493 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbZEaWf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 18:35:56 -0400
Message-ID: <4A2306F6.8020805@oracle.com>
Date: Sun, 31 May 2009 15:38:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] rapidio: fix kerneldoc for rio_mem_ops
References: <1243783538-18770-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1243783538-18770-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.4A230641.00F5:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Add structure name to the kerneldoc comment, so that we won't get
> a kdoc error:
> Error(include/linux/rio.h:336): cannot understand prototype: 'struct rio_mem_ops '
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  include/linux/rio.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/rio.h b/include/linux/rio.h
> index dd61538..9710506 100644
> --- a/include/linux/rio.h
> +++ b/include/linux/rio.h
> @@ -327,7 +327,7 @@ extern struct resource rio_resource;
>  #define release_rio_region(start, n) __release_region(&rio_resource, (start), (n))
>  
>  /**
> - * Struct for RIO memory definition.
> + * struct rio_mem_ops - struct for RIO memory definition.
>   * @map_inb: The function for mapping inbound memory window.
>   * @map_outb: The function for mapping outbound memory window.
>   * @unmap_inb: The function for unmapping inbound memory window.


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
