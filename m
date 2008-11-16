Return-Path: <linux-kernel-owner+w=401wt.eu-S1753703AbYKPPJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbYKPPJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 10:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYKPPJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 10:09:09 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51840 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752059AbYKPPJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 10:09:07 -0500
Date: Sun, 16 Nov 2008 15:09:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       crash-utility@redhat.com, Bernhard Walle <bwalle@suse.de>
Subject: Re: [PATCH 3/3] Remove CONFIG_STRICT_DEVMEM
Message-ID: <20081116150901.4d824e6d@lxorguk.ukuu.org.uk>
In-Reply-To: <1226846868-9595-4-git-send-email-bwalle@suse.de>
References: <1226846868-9595-1-git-send-email-bwalle@suse.de>
	<1226846868-9595-4-git-send-email-bwalle@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -#ifdef CONFIG_STRICT_DEVMEM
> -
>  int devmem_restricted = 1;
>  
> -#if defined(CONFIG_SYSCTL) && defined(CONFIG_STRICT_DEVMEM)
> +#if defined(CONFIG_SYSCTL)
>  	/*
>  	 * since there is no unload function, we don't have to deregister that
>  	 * the whole lifetime of the kernel and can ignore the return value

NAK - this adds a pile of memory wasting complete crap to every kernel
including embedded systems. At least before you could turn it off now you
can't.
