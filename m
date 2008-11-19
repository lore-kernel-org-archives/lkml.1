Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbYKSQkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbYKSQkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 11:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbYKSQkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 11:40:42 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:23559 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYKSQkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 11:40:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uRdtOhqOFJLtoRQCfz7lqlrNyZ4zwV9yC/HvFH+ZFuAh5f2fDcNlZHsYUHnozQqE8t
         Ne9OyrB9yuHZEzuzgcGw6G1hIBxnA963gXGRv2aQ4H9RmsQNRjGLNGzC6U6JF2Um0A2e
         5VycIgrr1SfQZ7p6yngxJUz51MNIdx6eBpjQc=
Date: Wed, 19 Nov 2008 11:40:35 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Henrik Rydberg <rydberg@euromail.se>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Complete support for the new unibody macbooks
Message-ID: <20081119113753.ZZRA012@mailhub.coreip.homeip.net>
References: <49109C91.6090207@euromail.se> <alpine.LNX.1.10.0811111835540.24889@jikos.suse.cz> <4919C979.3000501@euromail.se> <alpine.LNX.1.10.0811112347260.24889@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0811112347260.24889@jikos.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 11:48:31PM +0100, Jiri Kosina wrote:
> On Tue, 11 Nov 2008, Henrik Rydberg wrote:
> 
> > No worries. I should have mentioned earlier that the hid update is best 
> > synchronized with the bcm5974 update, since the latter is the only 
> > driver that will pick the mouse interface up after the hid update. The 
> > bcm5974 patch was sent on October 23, but I have not received any 
> > feedback to it yet.
> 
> Yes, I am aware of bcm5974 being dependent in HID driver not claiming the 
> mouse interface on this hardware.
> 
> Dmitry, what are your plans with this bcm5974 patch? 2.6.28 or 2.6.29?
> 

2.6.29 - the driver is in use so I did nto want to touch it after .28
merge window closed. Also I am moving to the west coast so swamped
anyways but I hope I will be somewhat settled after December 8th.

Btw, if you see something that you think needs to go into .28 for
input could please merge it for me? I also going to ask Linus to pull
from my for-linus branch in the next couple of days.

Thanks!

-- 
Dmitry
