Return-Path: <linux-kernel-owner+w=401wt.eu-S1761345AbZAFWg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761345AbZAFWg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757139AbZAFWWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:22:44 -0500
Received: from kroah.org ([198.145.64.141]:49339 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758641AbZAFWWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:22:42 -0500
Date: Tue, 6 Jan 2009 14:21:41 -0800
From: Greg KH <greg@kroah.com>
To: Jim Gettys <jg@laptop.org>
Cc: Henrik Rydberg <rydberg@euromail.se>, jkosina@suse.cz,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       Peter Hutterer <peter.hutterer@who-t.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] input: Add a detailed multi-touch finger data
	report protocol (rev2)
Message-ID: <20090106222141.GA685@kroah.com>
References: <495804B1.10300@euromail.se> <1231266769.8379.79.camel@jg-vaio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231266769.8379.79.camel@jg-vaio>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 01:32:49PM -0500, Jim Gettys wrote:
> There is a remaining question: how/whether to implement this interface
> in USB HID.....
> 
> On page 9 of the document you'll find at:
> http://www.microsoft.com/whdc/device/input/DigitizerDrvs_touch.mspx
> 
> Microsoft is claiming in that document of December 8 they are proposing
> the interfaces in the document to the USB IF organization, and that
> hardware vendors for Windows 7 should follow that spec.
> 
> Jiri, Greg:
> 
> 1) Does anyone know if Microsoft has actually made the proposal to the
> USB IF?  Is there anyone in the community watching/commenting on USB IF
> proposals?

Yes, I'm watching them, but nothing is public at this time (if it was
currently under review privately within the USB-IF, I wouldn't be
allowed to tell anyone, sorry.)

> 2) do you want generic USB HID patches or do you want to, for now,
> confine these to USB device specific drivers as much as possible?

As more devices should be showing up with this kind of support, it would
seem to make sense to add it to the HID core, right?

thanks,

greg k-h
