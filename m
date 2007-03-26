Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbXCZSH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbXCZSH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 14:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbXCZSH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 14:07:26 -0400
Received: from mxhost.fh-zwickau.de ([141.32.72.200]:15713 "EHLO
	mxhost.fh-zwickau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbXCZSH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 14:07:26 -0400
X-IronPort-AV: i="4.14,330,1170630000"; 
   d="scan'208"; a="17512593:sNHT28242448"
Date: Mon, 26 Mar 2007 20:07:16 +0200
From: Joerg Roedel <joro-lkml@zlug.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] riscom8: fix use of deprecated functions
Message-ID: <20070326180716.GA14554@zlug.org>
References: <20070325203601.GA13788@zlug.org> <20070326185209.GA5293@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326185209.GA5293@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 10:52:09PM +0400, Alexey Dobriyan wrote:
> On Sun, Mar 25, 2007 at 10:36:02PM +0200, Joerg Roedel wrote:
> > This patch replaces the deprecated functions in drivers/char/riscom8.c
> > and fixes the compile warnings they produced.
> 
> That's not the point of exercise. Make it SMP-safe, instead.

Thats not the excercise. The patch only removes the ugly compile time
warnings this driver produces. Thats what I can do without having the
hardware. But I know what you mean, maybe we should think about removing
this unmaintained piece of code completly. Are there actually users of
this driver with current kernels?

Joerg
