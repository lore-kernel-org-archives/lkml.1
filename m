Return-Path: <linux-kernel-owner+w=401wt.eu-S1754319AbYKFW5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbYKFW5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYKFW5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:57:25 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:44621 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbYKFW5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:57:24 -0500
Date: Thu, 6 Nov 2008 23:57:13 +0100
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pete Zaitcev <zaitcev@redhat.com>, Mattia Dongili <malattia@linux.it>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usb device not showing up
Message-ID: <20081106225713.GD11406@gamma.logic.tuwien.ac.at>
References: <20081106171958.GA17270@gamma.logic.tuwien.ac.at> <Pine.LNX.4.44L0.0811061423510.23473-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0811061423510.23473-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Do, 06 Nov 2008, Alan Stern wrote:
> Okay.  In the earlier (working) test, the modem showed up on bus 4, not
> bus 2.  Not that it matters much -- the modem didn't show up at all in

Sorry, it is always bus 4, i meant interface (or how do you call it) 2,
bus id 004:002

> this test, on any bus.  Its USB interface seems to be electrically
> disconnected or turned off.

Right.

> should start working, but I have no idea what that would be.  It's not 
> a USB issue; as far as USB is concerned the device just isn't there at 

Ok, if it is not an usb issue, I guess I have to hope for some fix in
sony-laptop module. 

> Interestingly, this trace appears to be missing some events.  There's a
> gap between timestamps 4284549076 and 4284645743 (the timestamps are in
> the second column) where we should see the initialization of bus 5 and
> bus 6.  Instead there's a 100-ms delay in which nothing happens,
> followed later on by the second initialization phase for those two
> buses.
> 
> I have to wonder...  Did you remove any part of the trace?  Did usbmon 

No. I sent you the output as it was saved on my hard disk. No editing
involved.

> malfunction?  Did parts of the initialization for those two buses 
> really get skipped (I can't imagine how)?

No idea. I can redo any tests you want, but I can guarantee that I
didn't tinker with the usbmon-bad.txt file itself, it was created with
	cat .../0u > usbmon-bad.txt

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
Someone down there
is trying to kill us!'
`Terrific,' said Arthur.
`But don't you see what this means?'
`Yes. We are going to die.'
`Yes, but apart from that.'
`APART from that?'
`It means we must be on to something!'
`How soon can we get off it?'
                 --- Zaphod and Arthur in a certain death situation over
                 --- Magrathea.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
