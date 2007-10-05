Return-Path: <linux-kernel-owner+w=401wt.eu-S1763442AbXJETTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763442AbXJETTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759354AbXJETTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:19:42 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:45762 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759093AbXJETTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:19:41 -0400
Date: Fri, 5 Oct 2007 15:19:40 -0400
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Cute feature: colored printk output
Message-ID: <20071005191940.GA4003@csclub.uwaterloo.ca>
References: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 09:13:40PM +0200, Jan Engelhardt wrote:
> +config VT_PRINTK_COLOR
> +	hex "Colored kernel message output"
> +	range 0x00 0xFF
> +	depends on VT_CONSOLE
> +	default 0x17

Shouldn't the default at least be what we already had?  Somehow grey on
blue sounds pretty hard to read to me.

--
Len Sorensen
