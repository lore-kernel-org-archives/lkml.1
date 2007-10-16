Return-Path: <linux-kernel-owner+w=401wt.eu-S1760860AbXJPE2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860AbXJPE2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 00:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbXJPE20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 00:28:26 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51871 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbXJPE2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 00:28:25 -0400
Date: Tue, 16 Oct 2007 06:29:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@computergmbh.de>, Rob Landley <rob@landley.net>
Cc: zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       randy.dunlap@oracle.com
Subject: Re: [PATCH] Allow kconfig to accept overrides
Message-ID: <20071016042957.GB27909@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0710122341530.16098@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710122341530.16098@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob & Jan.

On Fri, Oct 12, 2007 at 11:44:08PM +0200, Jan Engelhardt wrote:
> 
> Allow config variables in .config to override earlier ones in the same
> file. In other words,
> 
> 	# CONFIG_SECURITY is not defined
> 	CONFIG_SECURITY=y
> 
> will activate it. This makes it a bit easier to do
> 
> 	(cat original-config myconfig myconfig2 ... >.config)
> 
> and run menuconfig as expected.


How far is this from the miniconfig functionality?
Is it the same or can we achieve the miniconfig support
by extending Jan's patch?

See: http://lkml.org/lkml/2007/10/12/391

	Sam

