Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786Ab0A0AEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab0A0AEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731Ab0A0AEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:04:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687Ab0A0AEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:04:41 -0500
Date: Tue, 26 Jan 2010 16:03:10 -0800
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [72/98] ata_piix: enable 32bit PIO on SATA piix
Message-ID: <20100127000310.GA30178@suse.de>
References: <20100126233930.322296166@mini.kroah.org>
 <4B5F813D.9090003@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5F813D.9090003@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 08:56:45AM +0900, Tejun Heo wrote:
> On 01/27/2010 08:34 AM, Greg KH wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Tejun Heo <tj@kernel.org>
> > 
> > commit 0b67c7439fe2a5d76602de36854c88e2beab00b0 upstream.
> > 
> > Commit 871af1210f13966ab911ed2166e4ab2ce775b99d enabled 32bit PIO for
> > PATA piix but didn't for SATA.  There's no reason not to use 32bit PIO
> > on SATA piix.  Enable it.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Umm... I don't really think this would be necessary for -stable.  It
> probably won't break anything but at the same time this doesn't really
> fix any critical problem.

Ok, thanks for letting me know, I'll go drop it.  I found it when I was
looking for other changes in this area.

thanks,

greg k-h
