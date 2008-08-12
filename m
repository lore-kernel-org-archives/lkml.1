Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbYHLUBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbYHLUBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYHLUBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:01:34 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:45718 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYHLUBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:01:33 -0400
Date: Tue, 12 Aug 2008 16:01:10 -0400
From: Konrad Rzeszutek <ketuzsezr@darnok.org>
To: gregkh@suse.de
Cc: pjones@redhat.com, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] drivers/firmware/iscsi_ibft.c: make 3 functions static
Message-ID: <20080812200110.GA32627@andromeda.dapyr.net>
References: <20080423095230.GK28933@cs181133002.pp.htv.fi> <1218570239-17766-1-git-send-email-ketuzsezr@darnok.org> <1218570239-17766-2-git-send-email-ketuzsezr@darnok.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218570239-17766-2-git-send-email-ketuzsezr@darnok.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was suppose to include this nice little intro but I haven't
mastered the git-send-email yet. Here it is:

Dear Greg,

At your convience please include this patch in your update to the
drivers/firmware directory if it is not too much trouble.

Thank you,

Konrad Rzeszutek

On Tue, Aug 12, 2008 at 03:43:59PM -0400, Konrad Rzeszutek wrote:
> From: Adrian Bunk <bunk@kernel.org>
> 
> This patch makes the following needlessly global functions static:
> - ibft_attr_show_initiator()
> - ibft_attr_show_nic()
> - ibft_attr_show_target()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Konrad Rzeszutek <ketuzsezr@darnok.org>
> ---
>  drivers/firmware/iscsi_ibft.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
> index 8024e3b..8523811 100644
> --- a/drivers/firmware/iscsi_ibft.c
> +++ b/drivers/firmware/iscsi_ibft.c
> @@ -334,9 +334,9 @@ static void ibft_release(struct kobject *kobj)
>  /*
>   *  Routines for parsing the iBFT data to be human readable.
>   */
> -ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
> -				  struct ibft_attribute *attr,
> -				  char *buf)
> +static ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
> +					struct ibft_attribute *attr,
> +					char *buf)
>  {
>  	struct ibft_initiator *initiator = entry->initiator;
>  	void *ibft_loc = entry->header;
> @@ -376,9 +376,9 @@ ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
>  	return str - buf;
>  }
>  
> -ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
> -			    struct ibft_attribute *attr,
> -			    char *buf)
> +static ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
> +				  struct ibft_attribute *attr,
> +				  char *buf)
>  {
>  	struct ibft_nic *nic = entry->nic;
>  	void *ibft_loc = entry->header;
> @@ -440,9 +440,9 @@ ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
>  	return str - buf;
>  };
>  
> -ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
> -			       struct ibft_attribute *attr,
> -			       char *buf)
> +static ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
> +				     struct ibft_attribute *attr,
> +				     char *buf)
>  {
>  	struct ibft_tgt *tgt = entry->tgt;
>  	void *ibft_loc = entry->header;
> -- 
> 1.5.4.3
