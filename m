Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbXA2U4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbXA2U4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbXA2U4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:56:34 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56139 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbXA2U4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:56:33 -0500
Date: Mon, 29 Jan 2007 12:56:30 -0800
From: Andrew Morton <akpm@osdl.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab.c ifdef reduction breaks build
Message-Id: <20070129125630.dfba64a4.akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0701291240020.401@schroedinger.engr.sgi.com>
References: <20070129200517.GA6229@ccure.user-mode-linux.org>
	<Pine.LNX.4.64.0701291214060.32740@schroedinger.engr.sgi.com>
	<Pine.LNX.4.64.0701291240020.401@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 12:41:33 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> +#ifdef CONFIG_ZONE_DMA
>  		if (CONFIG_ZONE_DMA_FLAG)

We don't need the `if (CONFIG_ZONE_DMA_FLAG)' any more, do we?
