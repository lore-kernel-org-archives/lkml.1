Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbXFCM2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbXFCM2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 08:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759088AbXFCM2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 08:28:01 -0400
Received: from ns2.suse.de ([195.135.220.15]:48379 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758499AbXFCM2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 08:28:00 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] Kernel 2.6.22-rc3 breaks USB: Unable to get HID descriptor (error sending control message: Operation not permitted)
Date: Sun, 3 Jun 2007 12:48:27 +0200
User-Agent: KMail/1.9.1
Cc: Jiri Kosina <jikos@jikos.cz>, Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0706021841520.3376@p34.internal.lan> <Pine.LNX.4.64.0706031151090.29896@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0706031151090.29896@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706031248.28527.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 3. Juni 2007 11:55 schrieb Jiri Kosina:
> I have looked into NUT source and it seems that this error message is 
> output after interaction with libusb, not hiddev. It looks like libusb's 
> usb_claim_interface() or usb_control_msg() in in 2.6.22-rc3 is failing 
> with -EPERM.

Yes, strace and lsusb -v please.

	Regards
		Oliver
