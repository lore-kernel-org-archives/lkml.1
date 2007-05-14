Return-Path: <linux-kernel-owner+w=401wt.eu-S1760155AbXENFuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155AbXENFuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 01:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759497AbXENFuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 01:50:35 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:59245 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757748AbXENFuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 01:50:35 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Subject: Re: converting appletouch to usb autosuspend...
Date: Mon, 14 May 2007 07:50:39 +0200
User-Agent: KMail/1.9.1
Cc: Soeren Sonnenburg <kernel@nn7.de>, linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>, maxk@qualcomm.com
References: <1178995886.4168.10.camel@localhost> <1179103570.26132.8.camel@localhost> <200705140153.03084.s0348365@sms.ed.ac.uk>
In-Reply-To: <200705140153.03084.s0348365@sms.ed.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705140750.40458.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 14. Mai 2007 02:53 schrieb Alistair John Strachan:
> > What did you use instead of hci_usb then ? usbkbd ? This won't give you
> > the special keys etc...
> 
> Sorry, I wasn't clear. hci_usb is actually part of the BlueZ stack, it's got 
> nothing to do with the keyboard. I unloaded both appletouch AND hci_usb.

If you want large power savings from USB autosuspend, all
loaded drivers must support autosuspend. The HCD can suspend
only if all connected devices are suspended.
Are you willing to test patches for HID & the new last_busy based
usb core infrastructure?

	Regards
		Oliver
