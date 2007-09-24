Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbXIXNZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbXIXNZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbXIXNZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:25:05 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:39551 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338AbXIXNZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:25:04 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: USB autosuspend and turning of usb pendrive leds
Date: Mon, 24 Sep 2007 15:25:50 +0200
User-Agent: KMail/1.9.6 (enterprise 20070731.694771)
Cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
References: <46F3C704.5000203@hhs.nl> <200709241236.37406.oliver@neukum.org> <46F7A1CF.4010509@hhs.nl>
In-Reply-To: <46F7A1CF.4010509@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709241525.51187.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 24 September 2007 schrieb Hans de Goede:
> Oliver Neukum wrote:
> > Am Freitag 21 September 2007 schrieb Jiri Kosina:
> >> On Fri, 21 Sep 2007, Hans de Goede wrote:
> >>
> >>> Thats not what I had in mind, autosuspend doesn't work (presumably 
> >>> because hal keeps polling for media change) maybe I should fix hal to 
> >>> not keep polling for devices which don't have removable media?
> >> Hi Hans,
> >>
> >> I think the correct solution is that HAL stops polling the device as soon 
> >> as it sees that it got autosuspended.
> > 
> > And how would we notice a medium change then? If there's an alternative
> > way to notice it or we know it cannot happen there's no reason to poll at all.
> > 
> 
> It looks like hal is currently polling device of which it knows the medium is 
> not removable, like USB-pens.

It doesn't, which is the point. The overwhelming number of USB devices
don't bother to correctly declare themselves not removable SCSI devices.
The discrimination will have to happen on a product:vendor basis, which
means that a large database has to be built and maintained.

	Regards
		Oliver
