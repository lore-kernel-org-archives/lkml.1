Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbXCTPtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbXCTPtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 11:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbXCTPtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 11:49:11 -0400
Received: from waste.org ([66.93.16.53]:56971 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbXCTPtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 11:49:09 -0400
Date: Tue, 20 Mar 2007 10:36:27 -0500
From: Matt Mackall <mpm@selenic.com>
To: Keiichi KII <k-keiichi@bx.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC][PATCH -mm take3 1/6][resend] marking __init
Message-ID: <20070320153627.GF4892@waste.org>
References: <45FFCF31.3040000@bx.jp.nec.com> <45FFD272.6020105@bx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FFD272.6020105@bx.jp.nec.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 09:24:18PM +0900, Keiichi KII wrote:
> From: Keiichi KII <k-keiichi@bx.jp.nec.com>
> 
> This patch contains the following cleanups.
>  - add __init for initialization functions(option_setup() and
>    init_netconsole()).
> 
> Signed-off-by: Keiichi KII <k-keiichi@bx.jp.nec.com>
> Signed-off-by: Takayoshi Kochi <t-kochi@bq.jp.nec.com>
> ---
> Index: linux-mm/drivers/net/netconsole.c
> ===================================================================
> --- linux-mm.orig/drivers/net/netconsole.c
> +++ linux-mm/drivers/net/netconsole.c
> @@ -91,7 +91,7 @@ static struct console netconsole = {
>  	.write = write_msg
>  };
>  
> -static int option_setup(char *opt)
> +static int __init option_setup(char *opt)
>  {
>  	configured = !netpoll_parse_options(&np, opt);
>  	return 1;
> @@ -99,7 +99,7 @@ static int option_setup(char *opt)
>  
>  __setup("netconsole=", option_setup);
>  
> -static int init_netconsole(void)
> +static int __init init_netconsole(void)
>  {
>  	int err;

This is fine.

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.
