Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab0CERge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:36:34 -0500
Received: from nox.protox.org ([88.191.38.29]:39130 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab0CERgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:36:32 -0500
Date: Fri, 5 Mar 2010 18:36:25 +0100
From: Jerome Glisse <glisse@freedesktop.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Miller <davem@davemloft.net>, skeggsb@gmail.com, airlied@linux.ie,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       daniel@fooishbar.org, dri-devel@lists.sf.net, mingo@elte.hu,
       torvalds@linux-foundation.org
Subject: Re: [git pull] drm request 3
Message-ID: <20100305173625.GA2069@barney.localdomain>
References: <20100305154009.GC2505@tempa>
 <20100305.074835.159078083.davem@davemloft.net>
 <20100305160434.GE2505@tempa>
 <20100305.080626.09630724.davem@davemloft.net>
 <20100305163129.03b52797@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100305163129.03b52797@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 04:31:29PM +0000, Alan Cox wrote:
> On Fri, 05 Mar 2010 08:06:26 -0800 (PST)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: Daniel Stone <daniel@fooishbar.org>
> > Date: Fri, 5 Mar 2010 18:04:34 +0200
> > 
> > > So you're saying that there's no way to develop any reasonable body of
> > > code for the Linux kernel without committing to keeping your ABI
> > > absolutely rock-solid stable for eternity, no exceptions, ever? Cool,
> > > that worked really well for Xlib.
> > 
> > read() still works the same way it did 30 years ago last time I
> > checked.
> 
> Thats disingenous as read() is a method not an interface. It's also wrong
> because read() and write() behaviour has changed in various ways and old
> code broke because of it in subtle ways. Keeping the same method behaviour
> would have required things like new versions of read() for 64bit files,
> nonblocking, mandlocks, NFS, networking, etc all of which changed the
> core read() behaviour. I've yet to see anyone meaningfully argue it was
> the wrong thing to do.
> 
> Alan
> 

Also GPU API is way more complex than any others kernel API
(at least to my knowledge) and you can't know if the API you
have is the good one until you have a fully working & fast
3D driver ... and that takes either a lot of time with
a lot of people.

Cheers,
Jerome
