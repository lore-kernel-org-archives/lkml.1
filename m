Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbXL2MXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbXL2MXq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 07:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbXL2MXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 07:23:36 -0500
Received: from mojo.unsafe.ru ([83.222.2.183]:16968 "EHLO mojo.unsafe.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbXL2MXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 07:23:35 -0500
X-Greylist: delayed 1948 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Dec 2007 07:23:34 EST
Date: Sat, 29 Dec 2007 14:50:15 +0300
From: "Konstantin A. Lepikhov" <lakostis@unsafe.ru>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: How to Switch DMA off for only one Harddisk at Kernelboot
Message-ID: <20071229115015.GB24344@lks.home>
Mail-Followup-To: Gabriel C <nix.or.die@googlemail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <4765690C.6010605@j-o-a.de> <47657BA8.3020004@googlemail.com> <47657D79.7090100@j-o-a.de> <47658063.5010707@googlemail.com> <47658235.7050409@j-o-a.de> <47658B15.5090600@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47658B15.5090600@googlemail.com>
X-Operation-System: ALT Linux Sisyphus (20071206) 2.6.22-wks-smp-alt0.8
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gabriel!

Sunday 16, at 09:31:17 PM you wrote:

> Oliver Joa wrote:
> > Hi,
> > 
> > Gabriel C wrote:
> > 
> > [...]
> > 
> >>>> Also have a look at Documentation/ide.txt.
> >>> I read this already. Searching for "nodma" in this document gives only 
> >>> one line:
> >>>
> >>>   "ide=nodma"            : disable DMA globally for the IDE subsystem.
> >>>
> >>> If the documentation is correct hda=nodma and ideX=nodma should not 
> >>> work. I use kernel 2.6.23.1 at the moment.
> >> grep nodma Documentation/ide.txt
> >>  "hdx=nodma"            : disallow DMA
> >>
> >> ide=foo_option is for the whole ide sub-system where ideX|hdX=foo_option is just for that HDD.
> > 
> > 
> > /usr/src/linux-2.6.23.1$ grep nodma Documentation/ide.txt
> >   "ide=nodma"            : disable DMA globally for the IDE subsystem.
> > 
> > /usr/src/linux-2.6.21.5$ grep nodma Documentation/ide.txt
> >   "ide=nodma"            : disable DMA globally for the IDE subsystem.
> > 
> > /usr/src/linux-2.6.12# grep nodma Documentation/ide.txt
> >   "ide=nodma"            : disable DMA globally for the IDE subsystem.
> > 
> > Sorry, but I can not find this option, and it does not work. Which 
> > kernel do you use?
> 
> This is my devel box , running 2.6.24-rc5-git
Are you using modular or in-kernel IDE? Modules ignore cmdline options, so
you must pass this parameter directly to ide_core (e.g. ide_core
options="ide=nodma").

-- 
WBR et al.
