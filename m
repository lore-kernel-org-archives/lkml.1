Return-Path: <linux-kernel-owner+w=401wt.eu-S1767367AbXECEYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767367AbXECEYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 00:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767373AbXECEYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 00:24:19 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:54114 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767367AbXECEYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 00:24:18 -0400
Date: Thu, 3 May 2007 06:25:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christian Hesse <mail@earthworm.de>
Cc: linux-kernel@vger.kernel.org, James Ketrenos <jketreno@linux.intel.com>
Subject: Re: build system: no module target ending with slash?
Message-ID: <20070503042511.GB12644@uranus.ravnborg.org>
References: <200705030043.49208.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705030043.49208.mail@earthworm.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 12:43:43AM +0200, Christian Hesse wrote:
> Hi James, hi everybody,
> 
> playing with iwlwifi I try to patch it into the kernel and to build it from 
> there. But I have a problem with the build system.
> 
> The file drivers/net/wireless/mac80211/Makefile contains one single line:
> 
> obj-$(CONFIG_IWLWIFI)   += iwlwifi/
> 
> When CONFIG_IWLWIFI=m in scripts/Makefile.lib line 29 the target is filtered 
> as it ends with a slash. That results in 
> drivers/net/wireless/mac80211/built-in.o not being built and the build 
> process breaks with an error. What is the correct way to handle this? Why are 
> targets ending with a slash filtered?

Looks buggy. I will take a look tonight.

	Sam
