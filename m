Return-Path: <linux-kernel-owner+w=401wt.eu-S1757073AbYKUS4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbYKUS4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbYKUS4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:56:36 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:52285 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751942AbYKUS4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:56:36 -0500
Date: Fri, 21 Nov 2008 13:56:32 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Yi Yang <yi.y.yang@intel.com>
cc: David Brownell <david-b@pacbell.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] USB: improve ehci_watchdog's side effect in CPU power
 management
In-Reply-To: <1227279337.3447.22.camel@yangyi-dev>
Message-ID: <Pine.LNX.4.44L0.0811211354350.2376-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008, Yi Yang wrote:

> But on Asus EeePC, i saw another periodical timer usb_hcd_poll_rh_status
> which fires every 256 milisecond, is this also doing with some
> hardware's quirk?

That timer is associated mostly with UHCI controllers.  It is not 
because of a hardware quirk.  If the controller is suspended (for 
example, because no devices are attached to it) then the timer should 
stop.

Alan Stern

