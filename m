Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbXLFUFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbXLFUFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbXLFUFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:05:23 -0500
Received: from mx1.riseup.net ([204.13.164.18]:54654 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbXLFUFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:05:21 -0500
Date: Thu, 6 Dec 2007 21:05:42 +0100
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org
Subject: Re: [PATCH 3/3] printer port driver: semaphore to mutex
Message-ID: <20071206200542.GE480@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux@bohmer.net, jonathan@jonmasters.org
References: <20071206021857.826386004@mvista.com> <20071206021909.131993721@mvista.com> <20071206102334.GE17299@elte.hu> <1196958847.1568.98.camel@jnielson-xp.ddns.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196958847.1568.98.camel@jnielson-xp.ddns.mvista.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, Dec 06, 2007 at 08:34:06AM -0800 Daniel Walker ha dit:

> On Thu, 2007-12-06 at 11:23 +0100, Ingo Molnar wrote:
> > * Daniel Walker <dwalker@mvista.com> wrote:
> > 
> > > The port_mutex is actually a semaphore, so easily converted to a 
> > > struct mutex.
> > > 
> > > Signed-off-by: Daniel Walker <dwalker@mvista.com>
> > 
> > Acked-by: Ingo Molnar <mingo@elte.hu>
> > 
> > cool. How far away are we from being able to remove all the semaphore 
> > code? :-)
> 
> I wish my 7 patches made a dent, but it's hasn't done much. ;(
> 
> I would guess at least a week just to mop up the relatively easy ones..
> I've got 12 in my queue, and there still ~50 hopefully trivial ones
> still to be looked at.. Then another ~30 more difficult ones (that use
> init_MUTEX_LOCKED, or sema_init with 0 instead of 1) ..

I've also more patches of this type on my list, though i work in a
slower pace

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
