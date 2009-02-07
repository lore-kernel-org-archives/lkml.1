Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbZBGJCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbZBGJCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 04:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbZBGJCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 04:02:33 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:44795 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbZBGJCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 04:02:32 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 001/001]  usbserial: New mobile broadband modems to be supported through option module
Date: Sat, 7 Feb 2009 10:03:34 +0100
User-Agent: KMail/1.9.10
Cc: Dirk DeSchepper <ddeschepper@nvtl.com>,
       USB development list <linux-usb@vger.kernel.org>, smurf@smurf.noris.de,
       linux-kernel@vger.kernel.org
References: <12047829252365@kroah.org> <200902062023.07759.oliver@neukum.org> <20090206234716.GB31059@kroah.com>
In-Reply-To: <20090206234716.GB31059@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902071003.35856.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Saturday 07 February 2009 00:47:16 schrieb Greg KH:

> > The specifity is not affected at all.
> 
> If you look at the names that were changed, they are now more
> descriptive than before, always a good thing to have.

They are not descriptive. As far as USB devices have names,
these names _are_ the numbers. You will be very hard pressed
to guess from a name on a box that you may or may not have
which OEM's hardware really is in that box. If you have IDs
everything is clear. People who look at this code will mostly
have bug reports which will hopefully include lsusb, but not the
symbolic name in the kernel.

We dont do
*(base + 8) = 0xb3;
here. That would be bad. We use a clearly defined macro, USB_DEVICE
which takes id _numbers_. Device IDs have no meaning. They are meant
to be unique. You can give sensible names only to things that have meaning.

This is like doing
u8 init_string1[] = { INIT_STRING1_BYTE0, INIT_STRING1_BYTE1, ...

Don't make a fetish out of symbolic names.

	Regards
		Oliver

PS: Yes, I've had a professor who did prefer it this way.

