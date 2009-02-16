Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbZBPXXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbZBPXXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbZBPXXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:23:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35531 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbZBPXXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:23:12 -0500
Date: Tue, 17 Feb 2009 00:22:59 +0100
From: Pavel Machek <pavel@suse.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arve Hj?nnev?g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090216232259.GK1370@ucw.cz>
References: <200902160010.16955.rjw@sisk.pl> <20090216225831.GH1370@ucw.cz> <20090216231324.GA15435@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216231324.GA15435@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-02-16 23:13:24, Matthew Garrett wrote:
> On Mon, Feb 16, 2009 at 11:58:31PM +0100, Pavel Machek wrote:
> 
> > If no devices are being used, and next wakeup is far enough in the
> > future, just put system to sleep. Long enough == so far away that
> > suspend/wakeup is short compared to that... like 20 seconds on PC.
> 
> This is intrinsically difficult with PCs, since we have such a poorly 
> defined set of wakeup events. We can't wakeup on generic network 
> traffic, just WoL. 

At least e1000 in thinkpad can wakeup on generic network traffic. If
particular network card can't, you just can't sleep when network is up.

> Many machines won't wake up on keyboard events. 

Too bad. You'll have to close the lid for autosuspend to work on such
hw. (Or maybe you can do some hack telling the kernel to suspend
anyway if just keyboard prevents it.)

> Meanwhile, on embedded it's becoming a less interesting problem because 
> idle and suspended are often now equivalent states. 

Android people tell us otherwise.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
