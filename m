Return-Path: <linux-kernel-owner+w=401wt.eu-S932068AbXBKSs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbXBKSs4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 13:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932069AbXBKSs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 13:48:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:47592 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068AbXBKSs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 13:48:56 -0500
Date: Sun, 11 Feb 2007 10:47:27 -0800
From: Greg KH <greg@kroah.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Jiri Kosina <jikos@jikos.cz>, Jeff Garzik <jeff@garzik.org>, hjlipp@web.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-Usb-Devel <linux-usb-devel@lists.sourceforge.net>
Subject: Re: gigaset build broken on current linux-2.6.git
Message-ID: <20070211184727.GB15182@kroah.com>
References: <45CBA41D.3000406@garzik.org> <Pine.LNX.4.64.0702082344100.25686@twin.jikos.cz> <45CC3109.1010502@imap.cc> <45CF630F.1040706@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CF630F.1040706@imap.cc>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11, 2007 at 07:40:15PM +0100, Tilman Schmidt wrote:
> On Thu, 08 Feb 2007 14:02:31 +0100 I wrote:
> > Subject: Re: [linux-usb-devel] [PATCH 41/70] usbcore: remove unused bandwith-related code
> > 
> > This breaks compilation of drivers/isdn/gigaset/bas-gigaset.c.
> > If you pass on this patch, please pass on Andrew's
> > 
> > fix-gregkh-usb-usbcore-remove-unused-bandwith-related-code.patch
> > 
> > along with it.
> 
> On Fri, 09 Feb 2007 09:30:01 +0100, I wrote:
> > Jiri Kosina schrieb:
> >> ISDN: gigaset - remove forgotten urb->bandwidth reference
> >>
> >> Recent changes in usbcore removed the bandwidth field from struct urb.
> >> Remove the forgotten occurence in bas-gigaset.c
> >>
> >> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > Signed-off-by: Tilman Schmidt <tilman@imap.cc>
> 
> I notice that 2.6.20-git6 still doesn't include either of these fixes.
> Is there anything I need to do in order to push it?

It's in my queue and is on track to get in before 2.6.21-rc1 is out.

thanks,

greg k-h
