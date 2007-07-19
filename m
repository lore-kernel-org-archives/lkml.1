Return-Path: <linux-kernel-owner+w=401wt.eu-S940795AbXGSTfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940795AbXGSTfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938941AbXGSTfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:35:19 -0400
Received: from ns.suse.de ([195.135.220.2]:54011 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938830AbXGSTfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:35:16 -0400
Date: Thu, 19 Jul 2007 12:18:46 -0700
From: Greg KH <gregkh@suse.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kay.sievers@vrfy.org
Subject: Re: kobject link failure
Message-ID: <20070719191846.GA18871@suse.de>
References: <Pine.LNX.4.64.0707191956510.31013@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707191956510.31013@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 08:03:06PM +0200, Jan Engelhardt wrote:
> Hi,
> 
> 
> top is 275afcac9953ece0828972edeab9684cfe1a5ef3, error is:
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `store_uevent':
> core.c:(.text+0x20ebb): undefined reference to `kobject_actions'
> core.c:(.text+0x20edd): undefined reference to `kobject_actions'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [_all] Error 2
> 
> .config attached. Is it because of CONFIG_HOTPLUG=n?

Yes it is, are you really sure you want that?  :)

Kay, care to make up a patch to fix this issue?

thanks,

greg k-h
