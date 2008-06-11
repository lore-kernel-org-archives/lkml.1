Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbYFKON4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbYFKON4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 10:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbYFKONp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 10:13:45 -0400
Received: from styx.suse.cz ([82.119.242.94]:50700 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750832AbYFKONo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 10:13:44 -0400
Date: Wed, 11 Jun 2008 16:13:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com
Subject: Re: [PATCH 06/10] HID: move logitech report quirks
In-Reply-To: <484D070E.9050707@gmail.com>
Message-ID: <Pine.LNX.4.64.0806111611540.10085@jikos.suse.cz>
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-2-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-3-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-4-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-5-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-6-git-send-email-jirislaby@gmail.com>
 <Pine.LNX.4.64.0806041520140.10085@jikos.suse.cz> <484D070E.9050707@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008, Jiri Slaby wrote:

> > > static const struct hid_device_id hid_blacklist[] = {
> > > +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
> > > USB_DEVICE_ID_MX3000_RECEIVER) },
> > > +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER)
> > > },
> > > +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
> > > USB_DEVICE_ID_S510_RECEIVER_2) },
> > >  	{ }
> > >  };
> > This shouldn't be needed as soon as the userspace supports the proper module
> > autoloading, right?
> This is needed to tell generic drivers not to bind these, its' generic
> blacklist. I have no idea how this could be done better with current
> drivers/base/.

Hmm ... but if we make sure that the order in `modules.order' puts all the 
specialized drivers before the generic one, the binding should be done 
correctly even without blacklist, right?

-- 
Jiri Kosina
SUSE Labs
