Return-Path: <linux-kernel-owner+w=401wt.eu-S940753AbXGSTgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940753AbXGSTgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939542AbXGSTfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:35:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:44524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939236AbXGSTfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:35:20 -0400
Date: Thu, 19 Jul 2007 12:19:43 -0700
From: Greg KH <gregkh@suse.de>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kay.sievers@vrfy.org
Subject: Re: kobject link failure
Message-ID: <20070719191943.GB18871@suse.de>
References: <Pine.LNX.4.64.0707191956510.31013@fbirervta.pbzchgretzou.qr> <469FA94E.20002@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469FA94E.20002@googlemail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 08:11:26PM +0200, Gabriel C wrote:
> Jan Engelhardt wrote:
> > Hi,
> >
> >
> > top is 275afcac9953ece0828972edeab9684cfe1a5ef3, error is:
> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `store_uevent':
> > core.c:(.text+0x20ebb): undefined reference to `kobject_actions'
> > core.c:(.text+0x20edd): undefined reference to `kobject_actions'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > make: *** [_all] Error 2
> >
> > .config attached. Is it because of CONFIG_HOTPLUG=n?
> >   
> 
> Don't know but I got the same with randconfig today.
> 
> http://lkml.org/lkml/2007/7/19/349

Yes, that is the problem for your config also.

thanks,

greg k-h
