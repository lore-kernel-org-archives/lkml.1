Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbXD2Nke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbXD2Nke (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 09:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756474AbXD2Nkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 09:40:33 -0400
Received: from mail1.vetienne.net ([87.98.219.23]:2765 "EHLO
	mail1.vetienne.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265AbXD2Nkc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 09:40:32 -0400
From: Vincent ETIENNE <ve@vetienne.net>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [linux-usb-devel] USB HID bug (was [PROBLEM] Bonding driver in linux-2.6.21-rc6-mm1)
Date: Sun, 29 Apr 2007 15:40:27 +0200
User-Agent: KMail/1.9.6
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net, Paul Walmsley <paul@booyaka.com>
References: <Pine.LNX.4.44L0.0704281547260.14565-100000@netrider.rowland.org> <200704282243.54950.ve@vetienne.net> <Pine.LNX.4.64.0704291315080.7370@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0704291315080.7370@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704291540.28326.ve@vetienne.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le Sunday 29 April 2007 13:18:31 Jiri Kosina, vous avez écrit :
>
> Hi Vincent,

	Hi Jiri,

>
> yes, the device is messed up, but it shouldn't have any consequences for
> you - the HID driver is able to correctly handle that, so as soon as we
> don't need to add any extra quirks for such device, everything should be
> fine. I have removed the WARN_ON from the code in my tree. I think we
> still don't want users to add quirks for such broken devices (as it would
> collide with hid_blakclist[] terminator), so I have left the initial
> condition in usbhid_modify_dquirk() untouched.
>

Thanks a lot for the explanation and the patch, now i better understand 
the "problem". Sorry to have bother you with just noise. The patch will 
certainly be of some help with dumb user (who have dump hardware ) 
like me.

I have very appreciate the attention you ( and all other from this feed ) have 
take with me. So a big thanks for your work and the next time (if any), i 
will try to better analyse the problem to avoid unnecessary work.

Vincent
