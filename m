Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbZLCIdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbZLCIdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZLCIdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:33:36 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:40443 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbZLCIdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:33:35 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: root hub lost power or was reset
Date: Thu, 3 Dec 2009 09:33:47 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Robert Hancock <hancockrwd@gmail.com>,
       "Linux-usb" <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <dd18b0c30912021434t4a247646q48f32c0d0e40faae@mail.gmail.com> <4B1701EC.9030504@gmail.com> <4B170D46.9030701@gmail.com>
In-Reply-To: <4B170D46.9030701@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912030933.47769.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 3. Dezember 2009 01:58:46 schrieb Justin P. Mattock:
> >> Now looking at dmesg I see:
> >>
> >> [ 413.551845] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low)
> >> -> IRQ 23
> >> [ 413.551855] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> >> [ 413.551887] usb usb2: root hub lost power or was reset
> >
> > Is that unexpected? It seems reasonable to me..
> 
> honestly I can't remember seeing this or not.
> if this is normal then I'll leave it as is.

This happens if your system cuts power to USB during S2.
It trades a small reduction in energy consumption against
losing support for all devices whose drivers don't support
reset_resume().

This is a design feature of your system or BIOS, not a bug.

	Regards
		Oliver
