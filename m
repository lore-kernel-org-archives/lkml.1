Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbZCPLly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbZCPLly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 07:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbZCPLlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 07:41:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51305 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZCPLlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:41:45 -0400
Date: Mon, 16 Mar 2009 12:44:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29-rc5+: usb bluetooth crashes system
Message-ID: <20090316114441.GF2405@elf.ucw.cz>
References: <20090310112307.GD1337@ucw.cz> <20090314034852.GA3417@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090314034852.GA3417@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-03-13 20:48:52, Greg KH wrote:
> On Tue, Mar 10, 2009 at 12:23:07PM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > Since switch to 2.6.29-rc, bluetooth crashes system... usually on
> > disconnect or killall pppd.
> 
> Do we have a trace?

We have "bad magic" message, see bugzilla. I guess it is use of
spinlock after free?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
