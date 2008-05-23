Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbYEWSKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbYEWSKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 14:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbYEWSKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 14:10:40 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53713 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932AbYEWSKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 14:10:39 -0400
Date: Fri, 23 May 2008 20:11:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Message-ID: <20080523181118.GA32139@uranus.ravnborg.org>
References: <1211550282.28967.8.camel@pmac.infradead.org> <1211550374.28967.10.camel@pmac.infradead.org> <20080523164108.GA31545@uranus.ravnborg.org> <1211566051.28967.73.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211566051.28967.73.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 07:07:30PM +0100, David Woodhouse wrote:
> Er, is this my fault or was it like this already...
> 
> pmac /pmac/git/linux-2.6 $ make O=/pmac/git/foo 
>   GEN     /pmac/git/foo/Makefile
>   HOSTCC  scripts/kconfig/zconf.tab.o
> gcc: /pmac/git/linux-2.6/scripts/kconfig/zconf.tab.c: No such file or directory
> gcc: no input files

In some obscure cases I have seen this.
I never have had the energy to chase it down.

I recall I just deleted scripts/* from my output directory
and then it worked.
But this is maybe 4 months ago so memory is weak.

	Sam
