Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbXIXKfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbXIXKfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 06:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757034AbXIXKfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 06:35:45 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:35701 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbXIXKfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 06:35:44 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Jiri Kosina <jikos@jikos.cz>
Subject: Re: USB autosuspend and turning of usb pendrive leds
Date: Mon, 24 Sep 2007 12:36:37 +0200
User-Agent: KMail/1.9.6 (enterprise 20070731.694771)
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
References: <46F3C704.5000203@hhs.nl> <46F3D326.6050804@hhs.nl> <Pine.LNX.4.64.0709211715250.22331@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0709211715250.22331@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709241236.37406.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 21 September 2007 schrieb Jiri Kosina:
> On Fri, 21 Sep 2007, Hans de Goede wrote:
> 
> > Thats not what I had in mind, autosuspend doesn't work (presumably 
> > because hal keeps polling for media change) maybe I should fix hal to 
> > not keep polling for devices which don't have removable media?
> 
> Hi Hans,
> 
> I think the correct solution is that HAL stops polling the device as soon 
> as it sees that it got autosuspended.

And how would we notice a medium change then? If there's an alternative
way to notice it or we know it cannot happen there's no reason to poll at all.

	Regards
		Oliver



