Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbXIHImm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbXIHImm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 04:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbXIHImf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 04:42:35 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:57812 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbXIHImf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 04:42:35 -0400
Date: Sat, 8 Sep 2007 10:43:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
Message-ID: <20070908084357.GA22051@uranus.ravnborg.org>
References: <20070907124800.GP16806@vanheusden.com> <20070907083522.3191a4ba.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070907083522.3191a4ba.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2007 at 08:35:22AM -0700, Randy Dunlap wrote:
> On Fri, 7 Sep 2007 14:48:00 +0200 Folkert van Heusden wrote:
> 
> > Hi,
> > 
> > Maybe it is a nice enhancement for make menuconfig to more explicitly
> > give a pop-up or so when someone selects for example a sata controller
> > while no 'scsi-disk' support was selected?
> 
> I know that it's difficult to get people to read docs & help text,
> and maybe it is needed in more places, but CONFIG_ATA (SATA/PATA)
> help text says:
> 
>   NOTE: ATA enables basic SCSI support; *however*,
>   'SCSI disk support', 'SCSI tape support', or
>   'SCSI CDROM support' may also be needed,
>   depending on your hardware configuration.
> 
> 
> A popup makes some sense, but I don't know if menuconfig knows how to
> do popup warnings... and it needs to be done for all *configs,
> not just menuconfig.
For menuconfig I would much rather see that it had an additional
window at the bottom displaying the help text for the active menu line.

Implementing support for a pop-up in the kconfig language seems to be a bit
off the purpose of the kconfig language.

	Sam
