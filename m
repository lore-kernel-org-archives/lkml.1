Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZHYLg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZHYLg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 07:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbZHYLg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 07:36:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38697 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbZHYLg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 07:36:26 -0400
Date: Tue, 25 Aug 2009 13:36:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Linux USB <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Purpose of parameter in sysfs binary read
Message-ID: <20090825113619.GB1341@ucw.cz>
References: <9f97a27ccc13bd63ce99be04018b6bde.squirrel@intranet.cs.nmsu.edu> <20090818151427.GA6295@kroah.com> <ead4b2f9b7e5b1a415d010c524812e3a.squirrel@intranet.cs.nmsu.edu> <20090819170501.1dbd29a8@lxorguk.ukuu.org.uk> <5ea7c6a46fa1e051d69a302fdc8961ac.squirrel@intranet.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ea7c6a46fa1e051d69a302fdc8961ac.squirrel@intranet.cs.nmsu.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > If its a bitmap image why not register the device as a framebuffer ?
> >
> 
> Would that preclude it also being registered as a HID? The primary purpose
> of the device is to function as a keypad input.
> 
> But, in addition to sending keystroke output you can send a usb control
> message to change the backlight color and an interrupt message to load a
> bitmap as an image.
> 
> The bitmap itself is simple, but requires a specific format. Byte 0 must
> be 0x03 followed by 31 bytes of null. The low bit of byte 32 is x,y (0,0)
> second high bit is (0,1)... with low bit of byte 33 being (1,0)...

Sounds very much like auxdisplay things we already have in tree...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
