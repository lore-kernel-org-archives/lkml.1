Return-Path: <linux-kernel-owner+w=401wt.eu-S1765956AbYEESvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765956AbYEESvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765005AbYEESqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:46:42 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33415 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755875AbYEESql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:46:41 -0400
Message-ID: <481F55F8.1040606@cs.wisc.edu>
Date: Mon, 05 May 2008 13:46:16 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 4/8] scsi: use get_unaligned_* helpers
References: <1209700376.22362.19.camel@brick>
In-Reply-To: <1209700376.22362.19.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/scsi/libiscsi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 010c1b9..7646e86 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -508,7 +508,7 @@ invalid_datalen:
>  			goto out;
>  		}
>  
> -		senselen = be16_to_cpu(get_unaligned((__be16 *) data));
> +		senselen = get_unaligned_be16(data);
>  		if (datalen < senselen)
>  			goto invalid_datalen;
>  

This looks ok. Thanks.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

If It does not get picked up by Andrew then I will send it with the 
other iscsi updates when the next feature window opens.
