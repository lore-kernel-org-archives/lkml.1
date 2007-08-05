Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbXHELlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbXHELlo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 07:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbXHELlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 07:41:36 -0400
Received: from eazy.amigager.de ([213.239.192.238]:50486 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbXHELlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 07:41:35 -0400
Date: Sun, 5 Aug 2007 13:41:25 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-usb-devel@lists.sourceforge.net, Oliver Neukum <oliver@neukum.org>
Subject: Re: 2.6.23-rc1: USB hard disk broken
Message-ID: <20070805114125.GA22272@thinkpad.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-usb-devel@lists.sourceforge.net,
	Oliver Neukum <oliver@neukum.org>
References: <20070725072343.GA3483@dose.home.local> <200707251024.37112.oliver@neukum.org> <20070725181312.GA5612@dose.home.local> <200707261006.41368.oliver@neukum.org> <20070805110942.GA26278@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070805110942.GA26278@dose.home.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 13:09:42 +0200, Tino Keitel wrote:
> On Thu, Jul 26, 2007 at 10:06:40 +0200, Oliver Neukum wrote:
> > Am Mittwoch 25 Juli 2007 schrieb Tino Keitel:
> > > On Wed, Jul 25, 2007 at 10:24:36 +0200, Oliver Neukum wrote:
> > > > Am Mittwoch 25 Juli 2007 schrieb Tino Keitel:
> > > > > Hi,
> > > > > 
> > > > > I just tried 2.6.23-rc1 and shortly after the boot my external USB hard
> > > > > disk went mad.
> > > 
> > > [...]
> > > 
> > > > Please recompile with CONFIG_USB_DEBUG set.
> > > > 
> > > > 	Regards
> > > > 		Oliver
> > > 
> > > I tried, but it didn't happen again.
> > 
> > Did you try with the old kernel again? This bug may be related to timing.
> 
> I tried again -rc1 without USB_DEBUG, and was able to reproduce the
> bug 2 times. At the second time, the kernel log shows this:

Now I tried current git d4ac2477fad0f2680e84ec12e387ce67682c5c13 and I
can still reproduce it.

Regards,
Tino
