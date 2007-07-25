Return-Path: <linux-kernel-owner+w=401wt.eu-S1764116AbXGYGxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764116AbXGYGxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 02:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759824AbXGYGxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 02:53:12 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41580 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759648AbXGYGxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 02:53:11 -0400
Date: Wed, 25 Jul 2007 08:54:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: kai@germaschewski.name, LKML <linux-kernel@vger.kernel.org>
Subject: Re: make randconfig improvement
Message-ID: <20070725065426.GA24093@uranus.ravnborg.org>
References: <a8e1da0707242342s31166a5ax602fbcde8a299c97@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0707242342s31166a5ax602fbcde8a299c97@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 06:42:38AM +0000, Dave Young wrote:
> Hi,
> IMHO, the randconfig option make no sense sometimes. For me, My
> computer need some must-have config options, like SATA and USB
> keyboard config options. I think many other people maybe have similar
> problems.
> 
> So, what about improve the randconfig?  let's add some basic options ,
> like oldconfig.   We can use randconfig based user-defined options,
> randing except the pre-defined ones.
> 
> What's your opinons?

kconfig has support for reading a file specified by by
$KCONFIG_ALLCONFIG or if not specified for randconfig to read
a file named allrandom.config.

The syntax of the files are the same as in .config.

How far is this from what you try to achieve?

	Sam
