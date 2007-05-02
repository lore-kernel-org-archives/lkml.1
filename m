Return-Path: <linux-kernel-owner+w=401wt.eu-S2993195AbXEBWNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993195AbXEBWNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993199AbXEBWNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:13:08 -0400
Received: from ns2.suse.de ([195.135.220.15]:35434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993195AbXEBWNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:13:05 -0400
Date: Wed, 2 May 2007 15:04:33 -0700
From: Greg KH <gregkh@suse.de>
To: Jan Kratochvil <honza@jikos.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] [RFC] Added USB_DEVICE_INTERFACE_PROTOCOL
Message-ID: <20070502220433.GB21015@suse.de>
References: <Pine.LNX.4.64.0705021702040.13550@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705021702040.13550@twin.jikos.cz>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 05:03:05PM +0200, Jan Kratochvil wrote:
> The USB_DEVICE_INTERFACE_PROTOCOL will allow to match one interface
> protocol of vendor specific device.
> This macro is used in patch adding support for xbox360 to xpad.c
> 
> Signed-off-by: Jan Kratochvil <honza@jikos.cz>

I have no objection to this, other than you need an additional newline
after the #define :)

Dmitry, I can take this through my tree, or you can take it through
yours, as I think the other patches in this series depend on this.

If you want to take it through yours, feel free to add:
	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

to it.

thanks,

greg k-h
