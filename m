Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbXERUqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbXERUqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 16:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbXERUpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 16:45:54 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:34380 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbXERUpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 16:45:53 -0400
Date: Fri, 18 May 2007 22:46:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: John Sigler <linux.kernel@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: Dumping the checksums in a module
Message-ID: <20070518204650.GA17343@uranus.ravnborg.org>
References: <464DC019.6010008@free.fr> <Pine.LNX.4.61.0705182225450.9015@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705182225450.9015@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 10:27:06PM +0200, Jan Engelhardt wrote:
> 
> On May 18 2007 17:02, John Sigler wrote:
> >
> > I'm getting "disagrees about version of symbol struct_module" messages,
> > and I'm trying to understand why.
> >
> > As far as I understand (which is not very far), if I define
> > CONFIG_MODVERSIONS, then checksums for various functions (all exported
> > functions?) and various structures (which ones?) will be included inside
> > the kernel image, and written to Module.symvers. When an out-of-tree
> > module is built, it will also include these checksums.
> >
> > How do I list the checksums within a module?
> >
> > Is there a simpler way to list all the checksums?
> 
> 22:25 ichi:~ > modinfo aes
> srcversion:     8CB82B3A254D5A950FD0D14
> 
> I think this one checksum is computed out of all functions that
> the module uses.
It is computed based on all files used for the module.
Check help for "Loadable module support | Source Checksum for all modules"

	Sam
