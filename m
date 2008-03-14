Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbYCNSYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbYCNSYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 14:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758186AbYCNSYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 14:24:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3530 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758068AbYCNSYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 14:24:20 -0400
Date: Fri, 14 Mar 2008 19:24:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: David Newall <davidn@davidnewall.com>, "Fred ." <eldmannen@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Keys get stuck
Message-ID: <20080314182407.GA6990@ucw.cz>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> <Pine.LNX.4.64.0803121131200.7266@twin.jikos.cz> <47D7B428.6010804@davidnewall.com> <20080313171425.GA4840@ucw.cz> <Pine.LNX.4.64.0803141020380.30831@jikos.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803141020380.30831@jikos.suse.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-03-14 10:21:29, Jiri Kosina wrote:
> On Thu, 13 Mar 2008, Pavel Machek wrote:
> 
> > No.
> > hw is proper place to implement autorepeat, and along with some 
> > buffering, it has chance to work. Kernel is not real-time, and X are 
> > definitely not real-time, while autorepeat is real-time operation.
> > It actually mostly works in ps/2 case. Buffer in hardware means that 
> > pretty big interrupt delays can be tolerated without problems.
> 
> That's true. Unfortunately USB keyboards don't behave this way and there 
> is nothing we can do about that.

Maybe. (Could we get host controller to effectively timestamp usb
packets for us?)

..but that is not a problem here, because X are broken even on ps/2
keyboards. USB keyboards may be misdesigned, but they are not responsible
for problems we see.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
