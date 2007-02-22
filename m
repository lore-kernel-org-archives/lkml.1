Return-Path: <linux-kernel-owner+w=401wt.eu-S1945956AbXBVImo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945956AbXBVImo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945950AbXBVImo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:42:44 -0500
Received: from mx10.go2.pl ([193.17.41.74]:56404 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1945951AbXBVImm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:42:42 -0500
Date: Thu, 22 Feb 2007 09:46:10 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       "David S\. Miller" <davem@davemloft.net>,
       David Howells <dhowells@redhat.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFT] bridge: eliminate port_check workqueue
Message-ID: <20070222084610.GA2399@ff.dom.local>
References: <20070220221941.GA707@tv-sign.ru> <20070220162434.72d3ad7b@freekitty> <20070221082345.GB1662@ff.dom.local> <20070221142342.GB134@tv-sign.ru> <20070221105555.4d1b40a6@freekitty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221105555.4d1b40a6@freekitty>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 10:55:55AM -0800, Stephen Hemminger wrote:
> This is what I was suggesting by getting rid of the work queue completely.
...
> --- bridge.orig/net/bridge/br_if.c	2007-02-21 10:22:46.000000000 -0800
> +++ bridge/net/bridge/br_if.c	2007-02-21 10:53:25.000000000 -0800
> @@ -77,26 +77,15 @@
>   * Called from work queue to allow for calling functions that
>   * might sleep (such as speed check), and to debounce.
>   */

What about this comment?

> -static void port_carrier_check(struct work_struct *work)
> +void br_port_carrier_check(struct net_bridge_port *p)

Of course my opinion shouldn't matter here, but it looks
like withdrawing (or giving up) to the older way. So I'm
not excited, but I trust there is a reason for this. 

Cheers,
Jarek P.
