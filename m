Return-Path: <linux-kernel-owner+w=401wt.eu-S1752090AbYLXTL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbYLXTL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 14:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYLXTLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 14:11:46 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:50735 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751959AbYLXTLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 14:11:45 -0500
Date: Wed, 24 Dec 2008 22:11:43 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       linux-usb@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Driver for Freescale QUICC Engine USB Host
	Controller
Message-ID: <20081224191143.GA11060@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081223210322.GA2802@oksana.dev.rtsoft.ru> <Pine.LNX.4.44L0.0812232140400.8076-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0812232140400.8076-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 09:45:09PM -0500, Alan Stern wrote:
> On Wed, 24 Dec 2008, Anton Vorontsov wrote:
> 
> > This patch adds support for the FHCI USB controller, as found
> > in the Freescale MPC836x and MPC832x processors. It can support
> > Full or Low speed modes.
> > 
> > Quite a lot the hardware is doing by itself (SOF generation, CRC
> > generation and checking), though scheduling and retransmission is on
> > software's shoulders.
> > 
> > This controller does not integrate the root hub, so this driver also
> > fakes one-port hub. External hub is required to support more than
> > one device.
> 
> It looks like the kernel this was written for is several versions out 
> of date.

Yeah, originally it was written for 2.6.10. Though the driver I
posted is for the linux-next, and it works quite well w/o the
{un,}link_urb calls. ;-)

> The driver is missing some critical calls to functions like 
> usb_hcd_link_urb_to_ep().

Fixed.

Thanks for review!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
