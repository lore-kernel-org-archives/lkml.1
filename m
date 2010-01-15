Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab0AOLJF (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 06:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192Ab0AOLJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 06:09:04 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47704 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab0AOLJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 06:09:03 -0500
Date: Fri, 15 Jan 2010 11:08:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, David Miller <davem@davemloft.net>,
        stefanr@s5r6.in-berlin.de, adi@hexapodia.org, nm127@freemail.hu,
        david.vrabel@csr.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Palix <npalix@diku.dk>
Subject: Re: Changelog quality
Message-ID: <20100115110845.GB28625@sirena.org.uk>
References: <4B502C6B.7000802@s5r6.in-berlin.de> <20100115.005445.263291449.davem@davemloft.net> <tkrat.e88dd4dbf17f9bde@s5r6.in-berlin.de> <20100115.012233.202457727.davem@davemloft.net> <Pine.LNX.4.64.1001151039080.23543@ask.diku.dk> <84144f021001150149u3b784d26g1822be6c5c3ecbf@mail.gmail.com> <Pine.LNX.4.64.1001151101320.23543@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1001151101320.23543@ask.diku.dk>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 11:05:21AM +0100, Julia Lawall wrote:
> On Fri, 15 Jan 2010, Pekka Enberg wrote:

> > It seems to me that the scripts are kernel specific so why don't we
> > put those useful scripts _within_ the kernel source tree and introduce
> > a "make coccinelle-check" target?

> Indeed, perhaps a solution that would satisfy everyone would be to make a 
> place for scripts, perhaps with subdirectories for various tools, and then 
> when one submits a patch for tool X, one could then submit the script at 
> the same time (if it wasn't there already) and just refer to the script 
> that was used.  That way, if someone wants to know more about how the 
> change was made, they could look up the information, and if one does not, 
> then one would not be bother by having to scroll down to see the actual 
> patch.

This would also mean that other people could run and re-run the scripts
during development much more easily which would help improve the
coverage of new code.
