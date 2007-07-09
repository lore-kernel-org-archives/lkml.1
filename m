Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbXGIJWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbXGIJWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbXGIJWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:22:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38236 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbXGIJWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:22:06 -0400
Date: Mon, 9 Jul 2007 11:21:54 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Dan Aloni <da-x@monatomic.org>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070709092154.GA19705@suse.de>
Mail-Followup-To: Dan Aloni <da-x@monatomic.org>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20070706132814.GA7079@suse.de> <20070706145804.GA31409@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070706145804.GA31409@localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

* Dan Aloni <da-x@monatomic.org> [2007-07-06 16:58]:
> 
> Redhat has a makedumpinfo util which they intend to use as slim
> kernel-version-independent utility on kdump rootfs in order to
> save /proc/vmcore in a compact manner.

I think you mean makedumpfile, don't you?

> A patch that I am working on will make it possible to integrate
> the output of 'makedumpinfo -g' into vmlinux as the final build
> stage of the kernel. This information will be presented itself
> as /proc/kcore.info for the first kernel throughout its entire
> execution.

That sounds good. But I doubt that kernel developers like the idea of
needing another utility in the build process ...

> Then inside initramfs of the first kernel, a small 
> util will modify the vmlinux file of the kdump kernel before it
> gets loaded so that another special file appearing as 
> /proc/vmcore.info under the kdump kernel will present the same
> info. 

Where do you get the info from? If you're in the kdump initrd,
then the kdump kernel is already loaded. Do you want to attach the
info from the crashed kernel to the initrd of the kdump kernel?



Thanks,
   Bernhard
