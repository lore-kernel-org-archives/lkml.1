Return-Path: <linux-kernel-owner+w=401wt.eu-S1760092AbXH1Qq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092AbXH1Qq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 12:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758981AbXH1Qp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 12:45:59 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3561 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756854AbXH1Qp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 12:45:56 -0400
Subject: Re: [NET]: Mark Paul Moore as maintainer of labelled networking.
From: Joe Perches <joe@perches.com>
To: Paul Moore <paul.moore@hp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
In-Reply-To: <20070828130813.E6A1D39C199@ldl.fc.hp.com>
References: <200708280001.l7S01Cxt004543@hera.kernel.org>
	 <1188283579.6062.12.camel@localhost>
	 <20070828130813.E6A1D39C199@ldl.fc.hp.com>
Content-Type: text/plain
Date: Tue, 28 Aug 2007 09:45:50 -0700
Message-Id: <1188319550.6062.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-28 at 08:46 -0400, Paul Moore wrote:
> If having both a labeled networking and NetLabel maintainer entry is a
> problem then how about the patch below?

I don't think it is.

> -NETWORKING [LABELED] (NetLabel, CIPSO, Labeled IPsec, SECMARK)
> +NETWORKING [LABELED] (NetLabel/CIPSO, Labeled IPsec, SECMARK)
>  P:	Paul Moore
>  M:	paul.moore@hp.com
> +W:	http://netlabel.sf.net (NetLabel/CIPSO)
>  L:	netdev@vger.kernel.org
>  S:	Maintained

My preference would be for something like:

        NETLABEL and CIPSO
        P:	Paul Moore
        M:	paul.moore@hp.com
        W:	http://netlabel.sf.net
        L:	netdev@vger.kernel.org
        S:	Maintained
        F:	Documentation/netlabel/
        F:	include/net/netlabel.h
        F:	net/netlabel/
        
        Labeled IPsec and SECMARK
        P:	Paul Moore
        M:	paul.moore@hp.com
        L:	netdev@vger.kernel.org
        S:	Supported
        F:	include/linux/netfilter/*SECMARK*
        F:	net/netfilter/*SECMARK*
        
I would like to add appropriate file patterns for each
block.  Also, I'm not sure of the Supported/Maintained
status of each block.

The distinction is supposed to be:

        Supported:	Someone is actually paid to look after this.
        Maintained:	Someone actually looks after it.

Could you please clarify those for me?

cheers, Joe

