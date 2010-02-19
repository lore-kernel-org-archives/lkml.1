Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab0BTCnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 21:43:16 -0500
Received: from mail.perches.com ([173.55.12.10]:1114 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab0BTCnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 21:43:13 -0500
Subject: Re: [PATCH 2/3] get_maintainer: use references and closures
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100219070130.781454971@vyatta.com>
References: <20100219070108.670062169@vyatta.com>
	 <20100219070130.781454971@vyatta.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 08:08:06 -0800
Message-ID: <1266595686.8446.737.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-18 at 23:01 -0800, Stephen Hemminger wrote:
>      if (!$printed_novcs) {
> -	warn("$P: No supported VCS found.  Add --nogit to options?\n");
> -	warn("Using a git repository produces better results.\n");
> -	warn("Try Linus Torvalds' latest git repository using:\n");
> -	warn("git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git\n");
> +	warn "$P: No supported VCS found.  Add --nogit to options?\n",
> +	     "Using a git repository produces better results.\n",
> +	     "Try Linus Torvalds' latest git repository using:\n",
> +	"git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git\n";
>  	$printed_novcs = 1;

All other quoted string line continuations use periods.
Please use periods and resubmit.


