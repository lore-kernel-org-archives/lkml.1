Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbYKALH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbYKALH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 07:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYKALHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 07:07:20 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57680 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbYKALHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 07:07:18 -0400
Subject: Re: 2.6.27.2 USB reset/IO Error problem when high load on ICH9 USB
From: Kasper Sandberg <lkml@metanurb.dk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: LKML Mailinglist <linux-kernel@vger.kernel.org>
In-Reply-To: <490A5977.8090705@shaw.ca>
References: <fa.PPRUdlhLAQMsAcsErf8qHTGwTPQ@ifi.uio.no>
	 <490A5977.8090705@shaw.ca>
Content-Type: text/plain
Date: Sat, 01 Nov 2008 12:07:17 +0100
Message-Id: <1225537637.17253.53.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 19:03 -0600, Robert Hancock wrote:
> Kasper Sandberg wrote:
> > Hello..
> > 
> > I had to write an image to some usb flash drives, more specifically, 4GB
> > kingston datatraveler sticks, and i figured, instead of doing just 1 at
> > a time, i may aswell do 4, so i plugged in 4, and started 4 dd's of the
> > images, to sdc, sdd, sde, sdf. However, i got usb disconnects and IO
> > error messages from the kernel, these are at end of message. I had
> > previously done ~5 writes of images to 5 other flash disks with no
> > problem, but when i tried the next batch, those 4, it gave these errors.
> > I killed the dd's, pulled them all out, and put in 1 at a time, and it
> > worked perfectly.
> > 
> > unfortunately the first kernel messages have been flooded away. If you
> > need .config and/or the boot kernel messages, i can reboot and get it.
> 
> It seems suspicious that only the sde one (with address 6) seems to be 
> having problems. Are you sure that drive wasn't faulty or somehow not 
> plugged in properly?


I am absolutely positive it was plugged in properly, and i am also sure
the usb port isnt broken, i have tested all of them, though, this is
first time i have had so many in use concurrently, maybe its a power
issue? (which would be weird though, as flash devices shouldnt be using
so much power)

as for faulty, i did use that exact drive again, when i reverted back to
doing one by one.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

