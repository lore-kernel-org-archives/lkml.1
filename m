Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab0BRAcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 19:32:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60252
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753133Ab0BRAcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 19:32:01 -0500
Date: Wed, 17 Feb 2010 16:32:16 -0800 (PST)
Message-Id: <20100217.163216.50819747.davem@davemloft.net>
To: apetlund@simula.no
Cc: netdev@vger.kernel.org, ilpo.jarvinen@helsinki.fi, eric.dumazet@gmail.com,
       hannemann@nets.rwth-aachen.de, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, william.allen.simpson@gmail.com,
       damian@tvk.rwth-aachen.de, ebiederm@xmission.com
Subject: Re: [net-next PATCH v4 1/3] net: TCP thin-stream detection
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B7AAE60.3070305@simula.no>
References: <4B7AAE60.3070305@simula.no>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Petlund <apetlund@simula.no>
Date: Tue, 16 Feb 2010 15:40:32 +0100

>  
> +/* Determines whether this is a thin stream (which may suffer from
> + * increased latency). Used to trigger latency-reducing mechanisms.*/
> +static inline unsigned int tcp_stream_is_thin(struct tcp_sock *tp)
> +{
> +	return tp->packets_out < 4 && !tcp_in_initial_slowstart(tp);
> +}
> +
>  /* /proc */

Please format comments:

	/* Like this.  */

or:

	/* Like this.
	 * And this.
	 */

Thanks.
