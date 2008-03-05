Return-Path: <linux-kernel-owner+w=401wt.eu-S1762781AbYCEWNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762781AbYCEWNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbYCEWMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:12:55 -0500
Received: from us01smtp1.synopsys.com ([198.182.44.79]:47549 "EHLO
	boden.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619AbYCEWMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:12:54 -0500
Date: Wed, 5 Mar 2008 14:12:47 -0800
From: Joe Buck <Joe.Buck@synopsys.COM>
To: Michael Matz <matz@suse.de>
Cc: Jan Hubicka <hubicka@ucw.cz>, Aurelien Jarno <aurelien@aurel32.net>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction  flag
Message-ID: <20080305221247.GE17267@synopsys.com>
References: <20080305153020.GA24631@volta.aurel32.net> <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <20080305204234.GB17267@synopsys.com> <20080305204945.GB14011@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> <20080305212005.GC17267@synopsys.com> <Pine.LNX.4.64.0803052241170.20583@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803052241170.20583@wotan.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 10:43:33PM +0100, Michael Matz wrote:
> Hi,
> 
> On Wed, 5 Mar 2008, Joe Buck wrote:
> 
> > 
> > 
> > On Wed, 5 Mar 2008, Jan Hubicka wrote:
> > > > Linux kernel is disabling red zone and use kernel code model, yet the 
> > > > ABI is not going to be adjusted for that.
> > > > 
> > > > This is resonably easy to fix on kernel side in signal handling, or by
> > > > removing std usage completely
> > 
> > On Wed, Mar 05, 2008 at 10:02:07PM +0100, Michael Matz wrote:
> > > That is true.  But it requires updating the kernel to a fixed one if you 
> > > want to run your programs compiled by 4.3 :-/  Not something we'd like to 
> > > demand.
> > 
> > I changed the title just for emphasis.
> > 
> > I think that we can't ship 4.3.0 if signal handlers on x86/x86_64
> > platforms for both Linux and BSD systems will mysteriously (to the users)
> > fail, and it doesn't matter whose fault it is.
> 
> FWIW I don't think it's a release blocker for 4.3.0.  The error is arcane 
> and happens seldomly if at all.  And only on unfixed kernels.  A program 
> needs to do std explicitely, which most don't do _and_ get hit by a signal 
> while begin in a std region.  This happens so seldom that it didn't occur 
> in building the next openSuSE 11.0, and it continually builds packages 
> with 4.3 since months.
> 
> It should be worked around in 4.3.1 if at all.

OK, I suppose that I over-reacted, and it seems that the ship has sailed
in any case.

I agree that it's obscure, and I think that the only reason to worry is
if it introduces a means of attack, which seems unlikely.

