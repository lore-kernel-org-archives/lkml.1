Return-Path: <linux-kernel-owner+w=401wt.eu-S934186AbYETWJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934186AbYETWJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763840AbYETWJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:09:04 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:39558 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761451AbYETWJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:09:03 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Firmware loader driver for USB Apple iSight camera
Date: Wed, 21 May 2008 00:08:57 +0200
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       bersace03@laposte.net, johannes@sipsolutions.de
References: <20080520190628.GA14580@srcf.ucam.org> <200805202359.06873.oliver@neukum.org> <20080520220304.GA19116@srcf.ucam.org>
In-Reply-To: <20080520220304.GA19116@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805210008.58910.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 21 Mai 2008 00:03:04 schrieb Matthew Garrett:
> On Tue, May 20, 2008 at 11:59:05PM +0200, Oliver Neukum wrote:
> 
> > How does that simplify suspend/resume?
> > If the device looses its firmware due to suspend you must implement
> > this support in uvc, or a user space driver will be as good as this solution.
> 
> If it loses its firmwrare, it'll reattach with the old ID.

Thereby breaking the binding to the uvc driver. It'll be considered
a new device. You might just as well load the firmware through usbfs
triggered by udev.

If you really want to fix this you'd have to extend the persist
infrastructure first.

	Regards
		Oliver

