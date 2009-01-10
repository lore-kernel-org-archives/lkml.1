Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbZAJW5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbZAJW5t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbZAJW5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:57:41 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:48005 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbZAJW5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:57:40 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Kernelmessage to usbstick?
Date: Sat, 10 Jan 2009 23:58:00 +0100
User-Agent: KMail/1.9.10
Cc: Hans de Bruin <bruinjm@xs4all.nl>, linux-kernel@vger.kernel.org
References: <4968F346.8060806@xs4all.nl> <873afqhixw.fsf@basil.nowhere.org>
In-Reply-To: <873afqhixw.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901102358.00984.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Saturday 10 January 2009 23:53:15 schrieb Andi Kleen:
> Hans de Bruin <bruinjm@xs4all.nl> writes:
> 
> > Would it be possible to send kernel messages to an usbstick? On
> > poweroff my laptop displays a kernel trace and a final message:
> > poweroff[3114] exited with preempt_count 2
> > /etc/rc.d/rc.0: line 265: 3114 Segementation fault /sbin/poweroff.
> > I don't have a serial cable within reach, but plenty of usbsticks.
> 
> There's a mtdoops.c indeed, but it currently only works on
> MTD controlled flash devices, not usb sticks.
> 
> However usb sticks would need the USB subsystem to be running and it's
> unlikely that will be the case really late in poweroff.  So it might
> not help.

USB in turn needs PCI, interrupts and DMA.

	Regards
		Oliver
