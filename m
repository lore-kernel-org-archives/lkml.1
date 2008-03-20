Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbYCTTJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbYCTTJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 15:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbYCTTJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 15:09:21 -0400
Received: from rn-out-0910.google.com ([64.233.170.190]:2683 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbYCTTJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 15:09:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Rdbvktk4tEF+YnrAnoJGAqQdOHimWDlFPfHOd53Yx1+KHe95w868tuo7ADm2VljVCrluER5RaZmqgDNZNGBaeX2oxZJ5aUyOHggUz6iis9m/usU7AXa+vf0v+HKjjH/ybckbHDRaWEpUfetdCTWED6PVOYROCcb8LxYIwLqCoq8=
Subject: Re: [PATCH/RFC v3] introduce ARCH_CAN_UNALIGNED_ACCESS Kconfig
	symbol
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sam Ravnborg <sam@ravnborg.org>, Daniel Drake <dsd@gentoo.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <1206038734.16475.153.camel@johannes.berg>
References: <1206023695.16475.137.camel@johannes.berg>
	 <20080320181310.GA17884@uranus.ravnborg.org>
	 <1206038373.16475.150.camel@johannes.berg>
	 (sfid-20080320_184016_333600_B74BDE6D)  <1206038734.16475.153.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 20 Mar 2008 12:09:11 -0700
Message-Id: <1206040151.17059.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-20 at 19:45 +0100, Johannes Berg wrote:
> +For some ethernet hardware that cannot DMA to unaligned addresses like
> +4*n+2 or non-ethernet hardware, this can be a problem, and it is then
> +required to copy the incoming frame into an aligned buffer. Because this is
> +unnecessary on architectures that can do unaligned accesses, the code can be
> +made depend on CONFIG_HAVE_UNALIGNED_ACCESS_SUPPORT like so:
> +
> +#ifdef CONFIG_HAVE_UNALIGNED_ACCESS_SUPPORT
> +	skb = original skb
> +#else
> +	skb = copy skb
> +#endif
> +

Couldn't this just be made an inline in a networking header somewhere,
instead of ifdefs in the code?

Harvey

