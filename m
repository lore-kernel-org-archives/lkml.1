Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbXK0Rlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbXK0Rlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 12:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbXK0Rl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 12:41:28 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40172 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756565AbXK0Rl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 12:41:28 -0500
Date: Tue, 27 Nov 2007 12:41:23 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Andrew Morton <akpm@linux-foundation.org>, <kay.sievers@vrfy.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kobjects: drop child->parent ref at unregistration
In-Reply-To: <20071127170147.GB29109@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0711271235430.3037-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007, Greg KH wrote:

> For now, I'd recommend dropping it from your tree Andrew, as it might
> cause odd issues on device removal (not quite sure though...)

But then there's the counter-argument: If the patch does cause any odd 
issues to shake loose, learning about them in advance by exposing the 
patch in the -mm tree would be worthwhile.

Sounds like it's time for an executive decision...  :-)

Alan Stern

P.S.: I did test the patch by running the g_serial gadget with
usbserial loaded on the host.  Disconnecting the gadget while a user
process held the /dev/ttyUSB0 file open didn't cause any problems.

