Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYBJSim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYBJSim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 13:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYBJSif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 13:38:35 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:38737 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbYBJSie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 13:38:34 -0500
Date: Sun, 10 Feb 2008 20:38:29 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: zippel@linux-m68k.org, sam@ravnborg.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: kconfig creates strange (invalid?) configuration
Message-ID: <20080210183829.GF2436@cs181133002.pp.htv.fi>
References: <20080210143333.GC2436@cs181133002.pp.htv.fi> <20080210103026.27e639d3.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080210103026.27e639d3.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 10:30:26AM -0800, Randy Dunlap wrote:
> On Sun, 10 Feb 2008 16:33:33 +0200 Adrian Bunk wrote:
> 
> > The attached .config (with current -git) results in a compile 
> > error since it contains:
> > 
> > CONFIG_X86=y
> > # CONFIG_EMBEDDED is not set
> > CONFIG_SERIO=m
> > CONFIG_SERIO_I8042=y
> > 
> > Looking at drivers/input/serio/Kconfig I simply don't get how this 
> > can happen.
> 
> Is this from a 'make randconfig' or from one of the *config tools
> or done via a text editor (+ make oldconfig)?

This is my standard "everything modular" .config.

But I don't get the source of your question since it shouldn't matter 
where the .config comes from, and it stays this way after an oldconfig.

> ~Randy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

