Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbXAVU2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbXAVU2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 15:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbXAVU2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 15:28:52 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:54562 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbXAVU2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 15:28:51 -0500
Subject: Re: [linux-usb-devel] [GIT PATCH] USB fixes for 2.6.20-rc5
From: Marcel Holtmann <marcel@holtmann.org>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
In-Reply-To: <20070122202344.GA10579@suse.de>
References: <20070122200746.GA9936@kroah.com>
	 <1169496904.27023.11.camel@violet>  <20070122202344.GA10579@suse.de>
Content-Type: text/plain
Date: Mon, 22 Jan 2007 21:28:24 +0100
Message-Id: <1169497704.27023.13.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> > > They include a small number of fixes for some USB bugs, and some new
> > > device ids, all of the details are below.  I've also disabled the USB
> > > multithreaded probe option, as it broke a number of people's machines.
> > 
> > what about the two pending patches to make device_move() working as
> > expected. The current implementation is broken and basically useless.
> 
> I don't feel comfortable adding them to the 2.6.20 kernel at this late
> period, for a variety of reasons.  I really want them to be tested out
> in the -mm tree and then in the full -rc series due to the fact that
> they are non-trivial, and touch the driver core code that everyone uses,
> not just that function.

fair enough.

> Also, it's a new feature (reparent back to the original parent), not
> necessarily a bugfix.
> 
> And yes, I realize that the functions don't work fully right now, but as
> long as you don't want to re-parent the devices, they should work,
> right?

Actually even that was broken for me.

Regards

Marcel


