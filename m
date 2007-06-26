Return-Path: <linux-kernel-owner+w=401wt.eu-S1759872AbXFZUTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872AbXFZUTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 16:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759677AbXFZUSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 16:18:55 -0400
Received: from NEUROSIS.MIT.EDU ([18.95.3.133]:43317 "EHLO neurosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759674AbXFZUSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 16:18:54 -0400
X-Greylist: delayed 949 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jun 2007 16:18:54 EDT
Date: Tue, 26 Jun 2007 16:02:59 -0400
From: Jim Paris <jim@jtan.com>
To: Frederik Himpe <fhimpe@telenet.be>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22-rc6] NForce4 soft and hard resetting ports and exceptions
Message-ID: <20070626200259.GA5816@jim.sh>
References: <pan.2007.06.26.17.45.21@telenet.be> <pan.2007.06.26.18.54.37@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pan.2007.06.26.18.54.37@telenet.be>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frederik Himpe wrote:
> On Tue, 26 Jun 2007 17:45:22 +0000, Frederik Himpe wrote:
> 
> > I tried Linux 2.6.22-rc6 on my machine with an Asus A8N-SlI Deluxe
> > motherboard (NForce 4 chipset).
> > 
> > When booting, the system hangs for a long time, but it continues after a
> > long wait. I found these kind of errors in the logs afterwards:
> 
> [...]
> 
> > With Linux 2.6.21 this did not happen.
> > 
> > config, dmesg and lspci can be found here:
> > http://artipc10.vub.ac.be/kernelbug/
> 
> After disabling hddtemp and smartd services, these errors do not happen 
> anymore.

This was a bug in smartmontools.  It is fixed in CVS and should be in
the next released version.
  http://article.gmane.org/gmane.linux.utilities.smartmontools/4621

-jim
