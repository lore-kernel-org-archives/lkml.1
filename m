Return-Path: <linux-kernel-owner+w=401wt.eu-S932649AbXBPGX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbXBPGX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932651AbXBPGX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:23:27 -0500
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:46231 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649AbXBPGX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:23:26 -0500
Date: Fri, 16 Feb 2007 01:23:08 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Zwane Mwaikambo <zwane@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix modular AGPGART (ia64 allmodconfig)
Message-ID: <20070216062308.GD22490@athena.road.mcmartin.ca>
References: <Pine.LNX.4.64.0702152151460.12615@montezuma.fsmlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702152151460.12615@montezuma.fsmlabs.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 10:09:57PM -0800, Zwane Mwaikambo wrote:
> +ifeq ($(CONFIG_COMPAT),y)
> +agpgart-y			+= compat_ioctl.o
> +endif
> +

eh?

Couldn't this be?
agpgart-$(CONFIG_COMPAT)	+= compat_ioctl.o

Cheers,
	Kyle M.
