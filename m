Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbYE3W4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbYE3W4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYE3W4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:56:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185AbYE3W4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:56:24 -0400
Date: Fri, 30 May 2008 15:55:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: bjorn.helgaas@hp.com, tiwai@suse.de, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ISA: set 24-bit dma_mask for ISA devices.
Message-Id: <20080530155508.0b4e5776.akpm@linux-foundation.org>
In-Reply-To: <48408191.6030104@keyaccess.nl>
References: <4823AAF2.7070102@keyaccess.nl>
	<482B38D6.5030804@keyaccess.nl>
	<48406E8D.8050408@keyaccess.nl>
	<200805301543.42208.bjorn.helgaas@hp.com>
	<48407B99.4080209@keyaccess.nl>
	<48408191.6030104@keyaccess.nl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2008 00:37:05 +0200
Rene Herman <rene.herman@keyaccess.nl> wrote:

> [ PNP: set the pnp_card dma_mask for use by ISAPnP cards. ]
> 
> > Thanks. I'll assume Andrew picks it up from the CC...

Actually I would have missed it

> And here's the ISA one...
> 

If this one hadn't mentioned it.

> From: Rene Herman <rene.herman@gmail.com>
> Date: Sat, 31 May 2008 00:31:40 +0200
> Subject: [PATCH] ISA: set 24-bit dma_mask for ISA devices.
> 
> Set the ISA device dma_mask in preparation for using the actual device
> with the DMA API.

Argh.  Could we please be better with the changelogs?

This one tells us briefly what the patch does, but it deosn't tell us
why it does it.  It doesn't tell us whether it fixes some bug (and if
so what that bug is) and it gives me no means of determining whether
the patch is needed in 2.6.26 or in 2.6.25.x.

Ditto pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
