Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbZBYTpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbZBYTpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 14:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbZBYTp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 14:45:28 -0500
Received: from kroah.org ([198.145.64.141]:49205 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756855AbZBYTp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 14:45:28 -0500
Date: Wed, 25 Feb 2009 11:28:10 -0800
From: Greg KH <greg@kroah.com>
To: Alex Buell <alex.buell@munted.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Unused modules in 2.6.x
Message-ID: <20090225192810.GA6150@kroah.com>
References: <20090225175249.30e47b85@lithium.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225175249.30e47b85@lithium.local.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 05:52:49PM +0000, Alex Buell wrote:
> Hi,
> 
> Perhaps I missed something when the 2.6.x kernels got started a few
> years back, but why is it not possible for unused modules to be
> automatically unloaded anymore i.e with rmmod -a? I remember being able
> to do that with the 2.2.x and 2.4.x series a long time ago.

Because if you do that, lots of modules that were being "used" by the
system would get unloaded (usb host controllers, network drivers, etc.)

So it makes sense not to do that anymore.  See the linux-kernel archives
about 6 years ago for details if you are curious about this historical
issue (hint, it could burn you very badly even in 2.2 and 2.4...)

good luck,

greg k-h
