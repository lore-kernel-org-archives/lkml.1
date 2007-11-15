Return-Path: <linux-kernel-owner+w=401wt.eu-S1760072AbXKOR5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072AbXKOR5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 12:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbXKOR5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 12:57:38 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40358 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751718AbXKOR5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:57:37 -0500
Date: Thu, 15 Nov 2007 12:57:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Chuck Ebbert <cebbert@redhat.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       <stable@kernel.org>, <linux-usb-devel@lists.sourceforge.net>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Domenico Andreoli <cavokz@gmail.com>, <torvalds@linux-foundation.org>,
       <akpm@linux-foundation.org>, <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 20/40] USB: remove USB_QUIRK_NO_AUTOSUSPEND
In-Reply-To: <473C6AAF.5020901@redhat.com>
Message-ID: <Pine.LNX.4.44L0.0711151256370.14061-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, Chuck Ebbert wrote:

> On 11/15/2007 01:44 AM, Greg Kroah-Hartman wrote:
> > 
> > -stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > From: Alan Stern <stern@rowland.harvard.edu>
> > 
> > patch a691efa9888e71232dfb4088fb8a8304ffc7b0f9 in mainline.
> > 
> > This patch (as995) cleans up the remains of the former NO_AUTOSUSPEND
> > quirk.  Since autosuspend is disabled by default, we will let
> > userspace worry about which devices can safely be suspended.  Thus the
> 
> How is it disabled by default? I still see a default timeout of 2 in
> the code before this patch is applied.

It's supposed to be disabled by having the "power/level" attribute
automatically set to "on".

Alan Stern

