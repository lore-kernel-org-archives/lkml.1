Return-Path: <linux-kernel-owner+w=401wt.eu-S1759395AbXEUSiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395AbXEUSiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 14:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbXEUSh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 14:37:59 -0400
Received: from lilly.ping.de ([83.97.42.2]:4743 "HELO lilly.ping.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754957AbXEUSh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 14:37:59 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 May 2007 14:37:58 EDT
Date: Mon, 21 May 2007 20:20:05 +0200
From: Patrick Mau <mau@oscar.ping.de>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.1 on Fedora Core 6 breaks LVM/vgscan
Message-ID: <20070521182005.GA14390@oscar.prima.de>
References: <200705210632.l4L6Wkt0004225@turbo.physics.adelaide.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705210632.l4L6Wkt0004225@turbo.physics.adelaide.edu.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 04:02:46PM +0930, Jonathan Woithe wrote:
> On 21 May 2007 I wrote:
> 
> > Attempting to compile a 2.6.21.1 kernel for use on a Fedora Core 6 box
> > results in a panic at boot because the root filesystem can't be found.
> 
> I have just compiled 2.6.22-rc2 with the configuration file given in my
> previous post and the resulting kernel successfully boots on the machine
> concerned.  Whatever broke LVM for this machine in between 2.6.18 and
> 2.6.21.1 has now been fixed.

I recall that the device major number was moved to another place (253 ?)
Since this change caused many complaints, it was removed later on ...

> There is still a problem with the CDROM but I will follow up in another
> thread about that.

Did you mention ata_piix ?

With a recent git kernel, which I forgot, I was unable to read or eject
DVD's. (Un-encrypted, BTW).

Current git tree works fine again ...

Patrick

