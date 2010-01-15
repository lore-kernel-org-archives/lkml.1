Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab0AOKF3 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 05:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849Ab0AOKF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 05:05:28 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:42872 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808Ab0AOKF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 05:05:26 -0500
Date: Fri, 15 Jan 2010 11:05:21 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Miller <davem@davemloft.net>, stefanr@s5r6.in-berlin.de,
        adi@hexapodia.org, nm127@freemail.hu, david.vrabel@csr.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, cocci@diku.dk,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Palix <npalix@diku.dk>
Subject: Re: Changelog quality
In-Reply-To: <84144f021001150149u3b784d26g1822be6c5c3ecbf@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1001151101320.23543@ask.diku.dk>
References: <4B502C6B.7000802@s5r6.in-berlin.de>  <20100115.005445.263291449.davem@davemloft.net>
  <tkrat.e88dd4dbf17f9bde@s5r6.in-berlin.de>  <20100115.012233.202457727.davem@davemloft.net>
  <Pine.LNX.4.64.1001151039080.23543@ask.diku.dk>
 <84144f021001150149u3b784d26g1822be6c5c3ecbf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-511516320-822974405-1263549921=:23543"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511516320-822974405-1263549921=:23543
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 15 Jan 2010, Pekka Enberg wrote:

> Hi Julia,
> 
> On Fri, Jan 15, 2010 at 11:43 AM, Julia Lawall <julia@diku.dk> wrote:
> >> If you want more clear markers around the script so you can skim
> >> past it more efficiently when reading the commit message, then ask
> >> for that.
> >
> > If there were markers that would cause tools to hide some information
> > under a +, that would be great.  Sometimes I have simplified a script
> > beyond what would really be reusable just to not create an over-large
> > changelog.  I hope that the simplified version is at least understandable,
> > so that the reader can get an idea of what considerations went into the
> > change, but I recall in one case having messed up on that as well, and
> > ended up with something that really gave no information whatsoever.
> 
> It seems to me that the scripts are kernel specific so why don't we
> put those useful scripts _within_ the kernel source tree and introduce
> a "make coccinelle-check" target?

Indeed, perhaps a solution that would satisfy everyone would be to make a 
place for scripts, perhaps with subdirectories for various tools, and then 
when one submits a patch for tool X, one could then submit the script at 
the same time (if it wasn't there already) and just refer to the script 
that was used.  That way, if someone wants to know more about how the 
change was made, they could look up the information, and if one does not, 
then one would not be bother by having to scroll down to see the actual 
patch.

julia
---511516320-822974405-1263549921=:23543--
