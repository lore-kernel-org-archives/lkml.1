Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYIDP0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYIDP0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbYIDP0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:26:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41260 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750844AbYIDP0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:26:14 -0400
Date: Thu, 4 Sep 2008 11:26:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thiago Galesi <thiagogalesi@gmail.com>
cc: Alex Buell <alex.buell@munted.org.uk>, <linux-kernel@vger.kernel.org>,
       Robert Hancock <hancockr@shaw.ca>, Tomas Styblo <tripie@cpan.org>,
       <linux-usb@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device
 152d:2338
In-Reply-To: <82ecf08e0809040817l73b1bb9dn8d01212708feadd4@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0809041124430.2474-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008, Thiago Galesi wrote:

> > Oh yes, one other thing...  Have you tried hooking this drive directly
> > to an IDE cable (avoiding the USB-ATA adapter) to see if it works okay
> > in that environment?  If it does then you know where the bug is.
> 
> I'll try that. My bet is on the USB converter, since reloading the
> entire usb modules chain makes it work again
> Problem is I'm not using this drive as an 'external drive', rather,
> the jmicron device is in the motherboard, providing a 'native IDE
> port' in the MB (I know, I know)
> 
> Needless to say this works flawlessly in that other proprietary OS...

You could try using SnoopyPro to monitor the commands Windows sends to
the drive.

Alan Stern

