Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbYESKji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbYESKji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 06:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758133AbYESKjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 06:39:25 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:42862 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970AbYESKjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 06:39:21 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: [Bug #10630] USB devices plugged into dock are not discoverred until reload of ehci-hcd
Date: Mon, 19 May 2008 12:39:13 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <200805191002.43734.oliver@neukum.org> <20080519105150.GB4557@ics.muni.cz>
In-Reply-To: <20080519105150.GB4557@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805191239.14431.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 19 Mai 2008 12:51:50 schrieb Lukas Hejtmanek:
> On Mon, May 19, 2008 at 10:02:43AM +0200, Oliver Neukum wrote:
> > Can you compile with USB_DEBUG and attach the "register" file from
> > /sys/modules/ehci_hcd to see whether an interrupt is pending?
> 
> # gzip -dc /proc/config.gz | grep DEBUG | grep USB
> CONFIG_USB_DEBUG=y
> # CONFIG_USB_STORAGE_DEBUG is not set
> # CONFIG_USB_SERIAL_DEBUG is not set
> 
> which one is the file you want?
> 
> ls -F /sys/module/ehci_hcd/
> drivers/  holders/  initstate  notes/  parameters/  refcnt  sections/

Sorry, I was refering to the registers file as documented in
Documentation/usb/ehci.txt

	Regards
		Oliver

