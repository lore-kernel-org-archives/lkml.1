Return-Path: <linux-kernel-owner+w=401wt.eu-S1763090AbXELAJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763090AbXELAJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 20:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbXELAJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 20:09:20 -0400
Received: from ozlabs.org ([203.10.76.45]:47855 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755771AbXELAJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 20:09:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17989.1446.330976.16221@cargo.ozlabs.ibm.com>
Date: Sat, 12 May 2007 10:09:10 +1000
From: Paul Mackerras <paulus@samba.org>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, trivial@kernel.org
Subject: Re: [PATCH] spelling fixes: arch/powerpc/
In-Reply-To: <4644C734.3000303@simon.arlott.org.uk>
References: <4644C734.3000303@simon.arlott.org.uk>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Arlott writes:

> Spelling fixes in arch/powerpc/.

> -	/* Retreive CPU related informations from the flat tree
> +	/* Retreive CPU related information from the flat tree
	       ^^
You missed one. :)

> -	/* Clear the freeze bit, and reenable the interrupt.
> +	/* Clear the freeze bit, and re-enable the interrupt.

reenable -> re-enable is a bit marginal, but OK.

>  	/* Ok, now let's get cracking. You may ask me why I just didn't match
>  	 * the iic host from the iic OF node, but that way I'm still compatible
> -	 * with really really old old firmwares for which we don't have a node
> +	 * with really really old old firmware for which we don't have a node

I think "firmwares" here was meaning to imply there were more than one
instance or release of firmware which had the property described, and
your change loses that.

> -	 * differenciate them all and since that hack was there for a long
> +	 * differentiate them all and since that hack was there for a long

I haven't been too strict about the Franglais in the past, but OK. :)

Paul.
