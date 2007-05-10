Return-Path: <linux-kernel-owner+w=401wt.eu-S1760861AbXEJLkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760861AbXEJLkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758876AbXEJLkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:40:04 -0400
Received: from mtl.rackplans.net ([69.90.0.18]:55910 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760250AbXEJLkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:40:02 -0400
Date: Thu, 10 May 2007 07:40:00 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Robert Hancock <hancockr@shaw.ca>
cc: linux-kernel <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [2.6.21.1] SATA freeze
In-Reply-To: <46425DCE.1070001@shaw.ca>
Message-ID: <Pine.LNX.4.64.0705100739280.31317@mtl.rackplans.net>
References: <fa.Ngs+g4HBWK5JUzEhRMjcVQVR448@ifi.uio.no>
 <fa.xHed6JNWpYYFYmDy7FY+p6HTjPw@ifi.uio.no> <fa.I0i3SlPzvZnxCYuJNFL3tixqEJU@ifi.uio.no>
 <46425DCE.1070001@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Robert Hancock wrote:
> Gerhard Mack wrote:
> > On Wed, 9 May 2007, Jeff Garzik wrote:
> > > Gerhard Mack wrote:
> > > > May  9 14:51:35 mgerhard kernel: ata1.00: exception Emask 0x0 SAct 0x0
> > > > SErr
> > > > 0x1800000 action 0x2 frozen
> > > > May  9 14:51:35 mgerhard kernel: ata1.00: cmd
> > > > 35/00:00:80:6d:c8/00:04:09:00:00/e0 tag 0 cdb 0x0 data 524288 out
> > > > May  9 14:51:35 mgerhard kernel:          res
> > > > 40/00:c8:68:65:c8/84:00:09:00:00/e0 Emask 0x4 (timeout)
> > > > May  9 14:51:42 mgerhard kernel: ata1: port is slow to respond, please
> > > > be
> > > > patient (Status 0xd0)
> > > > 
> > > > Anything I can do to figgure out what's causing this?
> 
> You're showing various flags set in the SError register, which suggests you're
> having SATA communication problems with the drive. A bad SATA cable or power
> problems would be a strong possibility.
> 
> It really would be nice if we decoded these things more usefully for the user
> (same with the regular ATA errors, like drivers/ide does), but in general
> SError showing up as non-zero is a bad thing:
> 
> 0x400000 = "Handshake error: When set to one, this bit indicates that one or
> more R_ERR handshake response was received in response to frame transmission.
> Such errors may be the result of a CRC error detected by the recipient, a
> disparity or 10b/8b decoding error, or other error condition leading to a
> negative handshake on a transmitted frame."
> 
> 0x1800000 = "Link Sequence Error: When set to one, this bit indicates that one
> or more Link state machine error conditions was encountered since the last
> time this bit was cleared. The Link Layer state machine defines the conditions
> under which the link layer detects an erroneous transition."
> 
> and
> 
> "Transport state transition error: When set to one, this bit indicates that an
> error has occurred in the transition from one state to another within the
> Transport layer since the last time this bit was cleared."


Just out of curiosity how often is that bit cleared?

	Gerhard

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
