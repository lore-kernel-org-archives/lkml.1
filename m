Return-Path: <linux-kernel-owner+w=401wt.eu-S933996AbYBMRq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996AbYBMRq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933521AbYBMRqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:46:37 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:54373 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933731AbYBMRqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:46:36 -0500
Date: Wed, 13 Feb 2008 18:46:36 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Josh Boyer <jwboyer@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: latest list of unused Kconfig variables
Message-ID: <20080213174636.GB12259@uranus.ravnborg.org>
References: <alpine.LFD.1.00.0802130353530.31183@localhost.localdomain> <20080213073242.5c069c25@zod.rchland.ibm.com> <alpine.LFD.1.00.0802131002310.28617@localhost.localdomain> <20080213093314.3220e29d@zod.rchland.ibm.com> <alpine.LFD.1.00.0802131038130.30959@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802131038130.30959@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 10:44:27AM -0500, Robert P. J. Day wrote:
> On Wed, 13 Feb 2008, Josh Boyer wrote:
> 
> > OK.  Well all of your hits for 405EX, 440GRX, 440SPe, and
> > WANT_DEVICE_TREE in arch/powerpc seem bogus.  I dunno if you prune
> > those when reported or not.
> 
> not normally, but i don't know what you mean by "bogus":
> 
>   $ grep -r "config 405EX" *
>   arch/powerpc/platforms/40x/Kconfig:config 405EX
>   $
> 
>   $ grep -r CONFIG_405EX *
>   arch/powerpc/configs/makalu_defconfig:CONFIG_405EX=y
>   arch/powerpc/configs/kilauea_defconfig:CONFIG_405EX=y
>   $

$ git grep 405EX | grep select
arch/powerpc/platforms/40x/Kconfig:     select 405EX
arch/powerpc/platforms/40x/Kconfig:     select 405EX

So it is used.

	Sam
