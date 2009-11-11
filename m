Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbZKKWOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbZKKWOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 17:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759503AbZKKWOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 17:14:16 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:51857 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759472AbZKKWOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 17:14:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=niJMEojSvQHQvE+M1BUATMFjCS7aKwRx/H6jK0jYv5AoDZJa5Ncd2RO15YpwN0JWtd
         TpWOkfERYp56Dyzeo6glU9qEuaGhR/76LskD6cDKAU+zVcw1JEESqEyO0NHYkX7w2T3p
         1TQxQ5SqpfrGfyD0c1OHWer2PxrkMqnMnM4wQ=
Date: Wed, 11 Nov 2009 14:14:14 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mikko Vinni <mmvinni@yahoo.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: keyboard leds not restored after s2ram in
	2.6.32-rc6-00166-g799dd75
Message-ID: <20091111215029.GA13390@core.coreip.homeip.net>
References: <761296.29412.qm@web58402.mail.re3.yahoo.com> <20091111095218.GA3654@core.coreip.homeip.net> <800885.42568.qm@web58401.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <800885.42568.qm@web58401.mail.re3.yahoo.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 12:05:42PM -0800, Mikko Vinni wrote:
> Hi,
> 
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> > > my laptop shows the caps lock and scroll lock leds as being on after s2ram
> > > (and resume), even though they are off. If I press the caps lock key, the caps
> > > lock led stays on, the num lock led turns off, and the screen unlock screen
> > > warns about the caps lock being on.
> > > 
> > 
> > Thank you for the report. Could youplease tell me if the patch below
> > fixes the problem?
> 
> Yes, it does. Thanks, now my HP-dv5 is happy.
> 
> I did some tests suspending with the caps lock actually on, and it seems that
> in that case the user might still be confused (caps lock is on but led is off).
> At least on this machine this patch doesn't affect this theoretical problem
> either way (2.6.31 behaves similarly), so it is ok.
> 

Umm... so you are saying that even with .31 if you suspend with capslock
on it is off when you resume? Does it happen only in X or in console as
well?

-- 
Dmitry
