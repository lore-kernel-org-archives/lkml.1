Return-Path: <linux-kernel-owner+w=401wt.eu-S937669AbYEUUm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937669AbYEUUm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764481AbYEUUmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:42:12 -0400
Received: from mail.queued.net ([207.210.101.209]:1600 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761244AbYEUUmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:42:10 -0400
Date: Wed, 21 May 2008 16:47:03 -0400
From: Andres Salomon <dilinger@queued.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@codemonkey.org.uk>,
       Roland McGrath <roland@redhat.com>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: Additional kconfig targets (cloneconfig, nonint_oldconfig etc)
Message-ID: <20080521164703.61c7d715@ephemeral>
In-Reply-To: <20080502190949.GA30270@uranus.ravnborg.org>
References: <20080429183531.GB19652@uranus.ravnborg.org>
	<20080502190949.GA30270@uranus.ravnborg.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008 21:09:49 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> With the attached patch you can do:
> 
> make K=my_favourite_config defconfig
> 
> kconfig will read all config values form 'my_favourite_config'
> and set all other symbols to their default value.
> The output is now dense like this:
> # configuration is based on 'my_favourite_config'
> #
> # configuration written to .config
> #
> 


Is this slated for 2.6.27?


> 
> The K= notations works for the usual suspects:
> allnoconfig, allyesconfig, allmodconfig, randconfig and defconfig

Since this is aconf (automated), if we run 'make K=foo defconfig' and
'foo' doesn't contain one of the necessary values.. the build will fail,
right?

[...]
> 
> What is missing:
> 1) No support for .gz input file
>    But aconf.sh should be easy to adjust to this
> 
> 2) We hardcode that files name *_defconfig are found
>    in arch/$ARCH/configs/*
> 
> 3) Implement newsymbolsconfig (any better name?)
>    Shall list all new symbols and shall not write
>    any config
> 

I'm not sure I see the point of #3.
