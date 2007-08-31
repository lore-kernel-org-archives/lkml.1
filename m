Return-Path: <linux-kernel-owner+w=401wt.eu-S965883AbXHaRgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965883AbXHaRgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 13:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965405AbXHaRgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 13:36:06 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46795 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965146AbXHaRgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 13:36:05 -0400
Date: Fri, 31 Aug 2007 19:37:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stefano Esposito <ragnarok@email.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Failed to build latest git revision
Message-ID: <20070831173727.GB29304@uranus.ravnborg.org>
References: <20070831141957.d60c209a.ragnarok@email.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070831141957.d60c209a.ragnarok@email.it>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 02:19:57PM +0200, Stefano Esposito wrote:
> I've just git pull git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 
> after 
> $ make clean
> $ make menuconfig
> 
> make fails with: 
> $ make
> scripts/kconfig/conf -s arch/i386/Kconfig
> 
> *** Error during writing of the kernel configuration.

Looks like you lack write access to either .config, include/config/auto.conf or
a temporary file.
Did you build the kernel as root previously?

To clean up all files you can do:
copy .config save.config
make mrproper
mv save.confif .config

(And I use copy when backing up .config to avoid inherit
permissions from original .config file

	Sam
