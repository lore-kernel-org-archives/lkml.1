Return-Path: <linux-kernel-owner+w=401wt.eu-S1759828AbYBFWKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828AbYBFWKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbYBFWKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:10:08 -0500
Received: from smtp-out.google.com ([216.239.45.13]:34381 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbYBFWKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:10:06 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=m/qxHUtXhdB0cm5KkJyHSwLCn1c1LLkJgfi6q1TIy38tx5UxGY0uu4sNZzT/bLPL1
	s2yFwu1d1qvEwfqxwcl2g==
Date: Wed, 6 Feb 2008 14:09:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sven Wegener <sven.wegener@stealer.net>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: Make the synchronization interval controllable
In-Reply-To: <1202333990-19359-1-git-send-email-sven.wegener@stealer.net>
Message-ID: <alpine.DEB.1.00.0802061409130.7879@chino.kir.corp.google.com>
References: <1202333990-19359-1-git-send-email-sven.wegener@stealer.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, Sven Wegener wrote:

> diff --git a/net/ipv4/ipvs/ip_vs_sync.c b/net/ipv4/ipvs/ip_vs_sync.c
> index 948378d..9b57ad3 100644
> --- a/net/ipv4/ipvs/ip_vs_sync.c
> +++ b/net/ipv4/ipvs/ip_vs_sync.c
> @@ -143,6 +143,8 @@ char ip_vs_backup_mcast_ifn[IP_VS_IFNAME_MAXLEN];
>  /* multicast addr */
>  static struct sockaddr_in mcast_addr;
>  
> +/* milliseconds between synchronization runs */
> +int sysctl_ip_vs_sync_interval = 1000;
>  
>  static inline void sb_queue_tail(struct ip_vs_sync_buff *sb)
>  {

How useful is a negative ip_vs_sync_interval?
