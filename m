Return-Path: <linux-kernel-owner+w=401wt.eu-S971691AbXILSPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971691AbXILSPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 14:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbXILSO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 14:14:57 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:49060 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbXILSO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 14:14:56 -0400
Date: Wed, 12 Sep 2007 20:16:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: Dan Stromberg <dstromberglists@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Building a kernel-source RPM (not a kernel RPM)?
Message-ID: <20070912181621.GA18688@uranus.ravnborg.org>
References: <pan.2007.09.12.16.13.41.195991@gmail.com> <20070912170529.GA18311@uranus.ravnborg.org> <1189617081.31502.78.camel@tara.firmix.at> <20070912175116.GB18311@uranus.ravnborg.org> <1189620642.31502.104.camel@tara.firmix.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189620642.31502.104.camel@tara.firmix.at>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> But we are talking[0] about a kernel-source-$VERSION.$ARCH.rpm's which
> contain
> the kernel sources (read: lots of .c and .h files, etc.) - including a
> matching
> .config and after `make oldconfig` - so that one can build out-of-tree
> modules
> after installing it with "KSRC=" (or whatever the Makefile parameter is
> usually called).
You need certain things of the kernel built before you can build
external modules (if they use a sane build approach).
Just including the .config with the kernel source is far from enough.

	Sam
