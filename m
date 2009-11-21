Return-Path: <linux-kernel-owner+w=401wt.eu-S1752045AbZKUJRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbZKUJRx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 04:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbZKUJRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 04:17:52 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:48059 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZKUJRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 04:17:51 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v4] [RFC] NEXIO (or iNexio) support for usbtouchscreen
Date: Sat, 21 Nov 2009 10:17:58 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: linux-usb@vger.kernel.org, daniel.ritz@gmx.ch,
       linux-kernel@vger.kernel.org
References: <200911161515.00907.linux@rainbow-software.org> <200911201943.46696.oliver@neukum.org> <200911202341.31496.linux@rainbow-software.org>
In-Reply-To: <200911202341.31496.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911211017.58399.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 20. November 2009 23:41:29 schrieb Ondrej Zary:
> I'll also want to remove NEXIO_INPUT_EP and NEXIO_OUTPUT_EP constants -
>  the  endpoint addresses can be found at runtine (there's only one input
>  and one output endpoint). I think that to do this in nexio_init(), it
>  needs to know "struct usb_interface *" instead of "struct usb_device *". I
>  have a patch ready (but forgot to take it so it needs to wait until next
>  week) that replaces "struct usb_device *udev" in struct usbtouch_usb with
>  "struct usb_interface *interface" - is it a good idea?

Yes, it is a good idea. Everything else also looks good.

	Regards
		Oliver
