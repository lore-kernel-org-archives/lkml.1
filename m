Return-Path: <linux-kernel-owner+w=401wt.eu-S1763423AbXHCTpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763423AbXHCTpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 15:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758807AbXHCTps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 15:45:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbXHCTpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 15:45:47 -0400
Date: Fri, 3 Aug 2007 15:45:32 -0400
From: Dave Jones <davej@redhat.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Greg KH <gregkh@suse.de>, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by
	default on certain device classes
Message-ID: <20070803194532.GD16604@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Pete Zaitcev <zaitcev@redhat.com>,
	Oliver Neukum <oliver@neukum.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
	linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070802235613.GA9487@srcf.ucam.org> <20070803011505.GA32589@suse.de> <20070803014756.GA10392@srcf.ucam.org> <200708030957.46320.oliver@neukum.org> <20070803142416.GB11942@redhat.com> <20070803123447.00374108.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070803123447.00374108.zaitcev@redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 12:34:47PM -0700, Pete Zaitcev wrote:
 > On Fri, 3 Aug 2007 10:24:16 -0400, Dave Jones <davej@redhat.com> wrote:
 > > On Fri, Aug 03, 2007 at 09:57:45AM +0200, Oliver Neukum wrote:
 > >  
 > >  > Kernel developers are a diverser lot than you think ;-)
 > >  > We don't enable autosuspend in drivers we can't test, except where
 > >  > the lack of a kernel driver forces us to use a broad swipe. Printers
 > >  > were tested, too, and most printers seem to work.
 > > 
 > > My experience suggests the opposite.  Of the several I've tried so far,
 > > none have worked with usb suspend.
 > 
 > All of mine work. I'm wondering if this has something to do with
 > a hub or motherboard... How should we test it? Tried plugging elsewhere?

no hubs involved, directly plugged them into the mainboard.
Fairly recent Intel chipsets on all the systems I tested.

	Dave

-- 
http://www.codemonkey.org.uk
