Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbXITHA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbXITHA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbXITHAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:00:20 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:37951 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbXITHAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:00:19 -0400
Date: Thu, 20 Sep 2007 09:01:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Ph. Marek" <philipp@marek.priv.at>
Cc: Jeff Dike <jdike@addtoit.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: UML dead with current -git?
Message-ID: <20070920070114.GA8580@uranus.ravnborg.org>
References: <200709181714.34035@x5> <200709191443.24158@x5> <20070919085032.dd5c1732.randy.dunlap@oracle.com> <200709191817.51921@x5> <20070919180544.GA11860@c2.user-mode-linux.org> <39168.193.171.152.61.1190267089.squirrel@webmail.marek.priv.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39168.193.171.152.61.1190267089.squirrel@webmail.marek.priv.at>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 07:44:49AM +0200, Ph. Marek wrote:
> Hello Jeff,
> 
> > On Wed, Sep 19, 2007 at 06:17:51PM +0200, Philipp Marek wrote:
> >> How about that?
> >> 	readlink include/asm
> >> returns
> >> 	asm-um
> >> in my case, so I only have to strip the "asm-" part ...
> >
> > It doesn't handle O= directories...
> Sorry, I don't understand you. What are "0=" directories?

When building a kernel you can specify an other output directory
so you do not mix up your source tree with generated files.
To do so do like this:

Prepare the stuff:
mkdir ~/kernel
cp .config ~/kernel
make mrproper

And then build the kernel:
make O=~/kernel


	Sam
