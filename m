Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbXHEPoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbXHEPoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 11:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbXHEPoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 11:44:12 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:45567 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752538AbXHEPoL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 11:44:11 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Tino Keitel <tino.keitel@gmx.de>, David Brownell <david-b@pacbell.net>
Subject: Re: 2.6.23-rc1: USB hard disk broken
Date: Sun, 5 Aug 2007 17:46:32 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <20070725072343.GA3483@dose.home.local> <200707261006.41368.oliver@neukum.org> <20070805110942.GA26278@dose.home.local>
In-Reply-To: <20070805110942.GA26278@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708051746.32439.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 05 August 2007 schrieb Tino Keitel:
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
> > > >   Regards
> > > >           Oliver
> > > 
> > > I tried, but it didn't happen again.
> > 
> > Did you try with the old kernel again? This bug may be related to timing.
> 
> I tried again -rc1 without USB_DEBUG, and was able to reproduce the
> bug 2 times. At the second time, the kernel log shows this:
> 
> 2007-08-05_10:30:27.75572 kern.err: ehci_hcd 0000:00:1d.7: dev 6 ep1in scatterli
> st error 0/-121
> 2007-08-05_10:30:27.86576 kern.info: usb 1-6: reset high speed USB device using ehci_hcd and address 5
> 2007-08-05_10:30:55.95293 kern.info: usb 1-6: USB disconnect, address 5
> 2007-08-05_10:30:55.95300 kern.err: ehci_hcd 0000:00:1d.7: dev 6 ep1in scatterlist error -108/-108

David, does this error say anything to you?

	Regards
		Oliver

