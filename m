Return-Path: <linux-kernel-owner+w=401wt.eu-S1761214AbXK1PAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761214AbXK1PAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbXK1PAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:00:48 -0500
Received: from mx1.riseup.net ([204.13.164.18]:37764 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbXK1PAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:00:47 -0500
Date: Wed, 28 Nov 2007 16:00:55 +0100
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question regarding mutex locking
Message-ID: <20071128150055.GK20238@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Larry Finger <larry.finger@lwfinger.net>,
	LKML <linux-kernel@vger.kernel.org>
References: <474CF06C.8020208@lwfinger.net> <20071128081031.GF20238@traven> <474D7F5B.9090008@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474D7F5B.9090008@lwfinger.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, Nov 28, 2007 at 08:46:51AM -0600 Larry Finger ha dit:

> Matthias Kaehlcke wrote:
> > El Tue, Nov 27, 2007 at 10:37:00PM -0600 Larry Finger ha dit:
> > 
> >> If a particular routine needs to lock a mutex, but it may be entered with that mutex already locked,
> >> would the following code be SMP safe?
> >>
> >> hold_lock = mutex_trylock()
> >>
> >> ...
> >>
> >> if (hold_lock)
> >> 	mutex_unlock()
> > 
> > this is wont work, a mutex must not be released from another
> > context than the one that acquired it.
> 
> I thought that mutex_trylock() returned 1 if it got the lock and 0 if not. If that is true, wouldn't
> the if statement only unlock if the lock was obtained in this routine?

you're right, sorry i read to fast and interpreted that you want to
release the mutex in any case 

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

             You must have a plan. If you don't have a plan,
               you'll become part of somebody else's plan
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
