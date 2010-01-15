Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab0AOMGK (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 07:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301Ab0AOMGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 07:06:09 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:45279 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757273Ab0AOMGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 07:06:07 -0500
Date: Fri, 15 Jan 2010 13:06:04 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, David Miller <davem@davemloft.net>,
        stefanr@s5r6.in-berlin.de, adi@hexapodia.org, nm127@freemail.hu,
        david.vrabel@csr.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Palix <npalix@diku.dk>
Subject: Re: Changelog quality
In-Reply-To: <20100115110845.GB28625@sirena.org.uk>
Message-ID: <Pine.LNX.4.64.1001151303580.23543@ask.diku.dk>
References: <4B502C6B.7000802@s5r6.in-berlin.de> <20100115.005445.263291449.davem@davemloft.net>
 <tkrat.e88dd4dbf17f9bde@s5r6.in-berlin.de> <20100115.012233.202457727.davem@davemloft.net>
 <Pine.LNX.4.64.1001151039080.23543@ask.diku.dk>
 <84144f021001150149u3b784d26g1822be6c5c3ecbf@mail.gmail.com>
 <Pine.LNX.4.64.1001151101320.23543@ask.diku.dk> <20100115110845.GB28625@sirena.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jan 2010, Mark Brown wrote:

> On Fri, Jan 15, 2010 at 11:05:21AM +0100, Julia Lawall wrote:
> > On Fri, 15 Jan 2010, Pekka Enberg wrote:
> 
> > > It seems to me that the scripts are kernel specific so why don't we
> > > put those useful scripts _within_ the kernel source tree and introduce
> > > a "make coccinelle-check" target?
> 
> > Indeed, perhaps a solution that would satisfy everyone would be to make a 
> > place for scripts, perhaps with subdirectories for various tools, and then 
> > when one submits a patch for tool X, one could then submit the script at 
> > the same time (if it wasn't there already) and just refer to the script 
> > that was used.  That way, if someone wants to know more about how the 
> > change was made, they could look up the information, and if one does not, 
> > then one would not be bother by having to scroll down to see the actual 
> > patch.
> 
> This would also mean that other people could run and re-run the scripts
> during development much more easily which would help improve the
> coverage of new code.

On the other hand, one has to take into account the fact that at least in 
my case, the patches that are submitted are the ones that I have carefully 
checked for correctness.  Having a make target in the kernel might give 
some suggestion of quality that is perhaps not appropriate?

julia
