Return-Path: <linux-kernel-owner+w=401wt.eu-S932629AbXKPNDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629AbXKPNDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 08:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758779AbXKPNCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 08:02:55 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:2508 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757680AbXKPNCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 08:02:55 -0500
Date: Fri, 16 Nov 2007 14:02:39 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kconfig: use $K64BIT to set 64BIT with all*config targets
In-Reply-To: <20071115194412.d7e076ec.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0711161354290.1817@scrub.home>
References: <20071110204038.GA13140@uranus.ravnborg.org>
 <11947274093185-git-send-email-sam@ravnborg.org> <11947274091127-git-send-email-sam@ravnborg.org>
 <Pine.LNX.4.64.0711142116500.1818@scrub.home> <20071114220840.GB10920@uranus.ravnborg.org>
 <Pine.LNX.4.64.0711151616330.1817@scrub.home> <20071115192555.GD23914@uranus.ravnborg.org>
 <Pine.LNX.4.64.0711152036430.1817@scrub.home> <20071115204520.GA24851@uranus.ravnborg.org>
 <Pine.LNX.4.64.0711152158310.1817@scrub.home> <20071115220640.GA25265@uranus.ravnborg.org>
 <Pine.LNX.4.64.0711160205340.1817@scrub.home> <20071115194412.d7e076ec.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 15 Nov 2007, Randy Dunlap wrote:

> This all began (AFAIK) because some of us want to continue to be
> able to specify ARCH={i386,x86_64} on the (make) command line --
> not by using a .config file.  Taking away ARCH= on the command line
> is a regression (in some minds, at least), so Sam provided that
> capability.  Is that capability still present after this patch?

My patch does exactly that.
Sam's patch only made a subtle difference for all*config, but otherwise it 
would have made little difference, i.e. you still had to edit .config.

The maybe only remaining issue is which default config to use for 
defconfig, when ARCH isn't specified, but that is purely a Kbuild issue.

bye, Roman
