Return-Path: <linux-kernel-owner+w=401wt.eu-S1751294AbXBML4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbXBML4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 06:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbXBML4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 06:56:54 -0500
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:4916 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbXBML4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 06:56:53 -0500
Date: Tue, 13 Feb 2007 12:56:51 +0100
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, vince@arm.linux.org.uk
Subject: Re: [PATCH] mfd: SM501 core driver (#2)
Message-ID: <20070213115651.GA25015@roarinelk.homelinux.net>
References: <20070212110741.GA13208@trinity.fluff.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212110741.GA13208@trinity.fluff.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Mon, Feb 12, 2007 at 11:07:41AM +0000, Ben Dooks wrote:
> This is a new release of the SM501 MFD driver.

> +struct sm501_platdata_fbsub {
> +	struct fb_mode		*def_mode;
> +	unsigned long		 max_mem;
> +	unsigned int		 flags;
> +};

This may be a very dumb question, but where is 'struct fb_mode' declared?
I grepped through 2.6.19 and 2.6.20 (vanilla) and the closest matches
found are struct fb_modelist and struct fb_videomode.


Thanks,

-- 
 ml.
