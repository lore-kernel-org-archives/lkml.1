Return-Path: <linux-kernel-owner+w=401wt.eu-S1763767AbXHABtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763767AbXHABtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760482AbXHABth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:49:37 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:65086 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736AbXHABtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:49:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Cib330YQs1Q1K/59L1ivMBUi23y69Tt492W5mHEcyod0LaG5MKavDA/vWQKO+hw7WZOLD9uKfq/rUw0bopKKHl5QPQ6j33yAvlHHHyblKpYpIUYCTY5AnMXIpfqJRwyyicotqtrdLGCWStp3YG+j0fOigWhWQbPuLn3terPlm6w=
Message-ID: <46AFE6A0.4070405@googlemail.com>
Date: Wed, 01 Aug 2007 03:49:20 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Denis Cheng <crquan@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, chdebra@gmail.com
Subject: Re: [PATCH] net/sched: mark "NET_CLS_RSVP6 depends on IPV6"
References: <11859324914084-git-send-email-crquan@gmail.com>
In-Reply-To: <11859324914084-git-send-email-crquan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Cheng wrote:
> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
>  net/sched/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
> index 8a74cac..5d3749c 100644
> --- a/net/sched/Kconfig
> +++ b/net/sched/Kconfig
> @@ -300,6 +300,7 @@ config NET_CLS_RSVP
>  config NET_CLS_RSVP6
>  	tristate "IPv6 Resource Reservation Protocol (RSVP6)"
>  	select NET_CLS
> +	depends on IPV6
>  	---help---
>  	  The Resource Reservation Protocol (RSVP) permits end systems to
>  	  request a minimum and maximum data flow rate for a connection; this

	
I thought the same but ... see 

http://marc.info/?l=linux-kernel&m=118440958516205&w=2
http://marc.info/?l=linux-netdev&m=118442747709230&w=2

Regards,

Gabriel
