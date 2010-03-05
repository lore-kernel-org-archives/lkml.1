Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab0CEQ26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:28:58 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53521 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752455Ab0CEQ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:28:56 -0500
Date: Fri, 5 Mar 2010 16:31:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: daniel@fooishbar.org, skeggsb@gmail.com, airlied@linux.ie,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       dri-devel@lists.sf.net, mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: [git pull] drm request 3
Message-ID: <20100305163129.03b52797@lxorguk.ukuu.org.uk>
In-Reply-To: <20100305.080626.09630724.davem@davemloft.net>
References: <20100305154009.GC2505@tempa>
	<20100305.074835.159078083.davem@davemloft.net>
	<20100305160434.GE2505@tempa>
	<20100305.080626.09630724.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Mar 2010 08:06:26 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Daniel Stone <daniel@fooishbar.org>
> Date: Fri, 5 Mar 2010 18:04:34 +0200
> 
> > So you're saying that there's no way to develop any reasonable body of
> > code for the Linux kernel without committing to keeping your ABI
> > absolutely rock-solid stable for eternity, no exceptions, ever? Cool,
> > that worked really well for Xlib.
> 
> read() still works the same way it did 30 years ago last time I
> checked.

Thats disingenous as read() is a method not an interface. It's also wrong
because read() and write() behaviour has changed in various ways and old
code broke because of it in subtle ways. Keeping the same method behaviour
would have required things like new versions of read() for 64bit files,
nonblocking, mandlocks, NFS, networking, etc all of which changed the
core read() behaviour. I've yet to see anyone meaningfully argue it was
the wrong thing to do.

Alan


