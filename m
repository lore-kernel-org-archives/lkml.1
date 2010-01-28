Return-Path: <linux-kernel-owner+w=401wt.eu-S932291Ab0A1Sj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab0A1Sj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 13:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796Ab0A1Sj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 13:39:58 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:53389 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab0A1Sj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 13:39:58 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Greg KH <greg@kroah.com>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Thu, 28 Jan 2010 19:40:12 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100117025535.GB7045@srcf.ucam.org> <201001191420.29652.oliver@neukum.org> <20100128174546.GC19871@kroah.com>
In-Reply-To: <20100128174546.GC19871@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001281940.12173.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 28. Januar 2010 18:45:46 schrieb Greg KH:
> On Tue, Jan 19, 2010 at 02:20:29PM +0100, Oliver Neukum wrote:
> > Am Montag, 18. Januar 2010 21:14:16 schrieb Matthew Garrett:
> > 
> > > drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 1565 
> > > bytes
> > > drivers/usb/serial/generic.c: usb_serial_generic_write - put 0 bytes 
> > > into fifo
> > > drivers/usb/serial/generic.c: usb_serial_generic_read_bulk_callback - 
> > > port 0
> > 
> > If the FIFO is full we can do nothing. Please try the attached patch.
> 
> Did we ever determine if the patch below is needed or not?

No. Further discussion cast serious doubt on it, but we have no
experimental evidence I am aware of.

	Regards
		Oliver
