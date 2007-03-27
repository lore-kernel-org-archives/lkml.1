Return-Path: <linux-kernel-owner+w=401wt.eu-S1752431AbXC0Xw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbXC0Xw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 19:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbXC0Xw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 19:52:58 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36500 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752431AbXC0Xw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 19:52:57 -0400
Date: Wed, 28 Mar 2007 01:53:00 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>, ralf@linux-mips.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips@linux-mips.org
Subject: Re: dead CONFIG variables in kernel Makefiles
Message-ID: <20070327235259.GL16477@stusta.de>
References: <Pine.LNX.4.64.0703261924470.26815@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703261924470.26815@CPE00045a9c397f-CM001225dbafb6>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 07:32:00PM -0400, Robert P. J. Day wrote:
> 
>   the output from a short script i wrote, locating all CONFIG_
> variables in makefiles that don't appear to exist in any Kconfig file
> anywhere in the source tree.
> 
>   first, from the drivers/ directory:
>...
> ===== ZS =====
> ./drivers/tc/Makefile:obj-$(CONFIG_ZS) += zs.o
>...

Ralf, is there any reason why the code for this driver is in Linus' 
tree, but the option (that is in the mips tree) is missing?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

