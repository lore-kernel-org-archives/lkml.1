Return-Path: <linux-kernel-owner+w=401wt.eu-S1764856AbYA2Aak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764856AbYA2Aak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758359AbYA2AaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:30:18 -0500
Received: from iabervon.org ([66.92.72.58]:55288 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757055AbYA2AaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:30:17 -0500
Date: Mon, 28 Jan 2008 19:30:09 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Mike Frysinger <vapier.adi@gmail.com>
cc: richard kennedy <richard@rsk.demon.co.uk>, bryan.wu@analog.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bryan Wu <cooloney.lkml@gmail.com>
Subject: Re: [rfc] exposing MMR's of on-chip peripherals for debugging
 purposes
In-Reply-To: <8bd0f97a0801281615w6fbdd77aifda714685f56cc41@mail.gmail.com>
Message-ID: <alpine.LNX.1.00.0801281919490.13593@iabervon.org>
References: <8bd0f97a0801280216x56d52028s2ea247dd969e85e2@mail.gmail.com>  <1201516811.7547.46.camel@roc-laptop>  <8bd0f97a0801280306k5dc4410eu208bc55f1975ceb8@mail.gmail.com>  <479DD2F3.6020209@rsk.demon.co.uk>  <8bd0f97a0801280510q42dbf5d3i947877b7e3454fe1@mail.gmail.com>
  <alpine.LNX.1.00.0801281901130.13593@iabervon.org> <8bd0f97a0801281615w6fbdd77aifda714685f56cc41@mail.gmail.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008, Mike Frysinger wrote:

> On Jan 28, 2008 7:08 PM, Daniel Barkalow <barkalow@iabervon.org> wrote:
> > Could you submit the XML files and the autogeneration code? The C file
> > isn't really source. Not only is it big, it'll probably change around a
> > whole lot when you make small changes to your process, be hard to review,
> > etc.
> 
> that would require the build system to have xml tools installed ...
> that doesnt sound pleasant.

If they're only required for building blackfin debugging stuff, that 
shouldn't be a big deal. People building embedded kernels with debugging 
from source can probably handle the extra requirement. Setting up a 
cross-compilation toolchain for embedded processors is much trickier than 
getting xml tools.

> that said, the XML files in question are probably 10x+ the size of the
> C file.  swapping 1 meg for 10+ megs ? :)

If it's a bunch of smaller files, and if changes tend to be localized, 
that would be a good tradeoff. Alternatively, have them packaged 
separately, which might be more appropriate anyway if people might want to 
use them for other purposes (on the host when using jtag, perhaps).

	-Daniel
*This .sig left intentionally blank*
