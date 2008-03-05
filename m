Return-Path: <linux-kernel-owner+w=401wt.eu-S1759731AbYCEVU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731AbYCEVU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbYCEVUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:20:15 -0500
Received: from us01smtp1.synopsys.com ([198.182.44.79]:46123 "EHLO
	boden.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbYCEVUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:20:14 -0500
Date: Wed, 5 Mar 2008 13:20:05 -0800
From: Joe Buck <Joe.Buck@synopsys.COM>
To: Michael Matz <matz@suse.de>
Cc: Jan Hubicka <hubicka@ucw.cz>, Aurelien Jarno <aurelien@aurel32.net>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Message-ID: <20080305212005.GC17267@synopsys.com>
References: <20080305153020.GA24631@volta.aurel32.net> <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <20080305204234.GB17267@synopsys.com> <20080305204945.GB14011@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 5 Mar 2008, Jan Hubicka wrote:
> > Linux kernel is disabling red zone and use kernel code model, yet the 
> > ABI is not going to be adjusted for that.
> > 
> > This is resonably easy to fix on kernel side in signal handling, or by
> > removing std usage completely

On Wed, Mar 05, 2008 at 10:02:07PM +0100, Michael Matz wrote:
> That is true.  But it requires updating the kernel to a fixed one if you 
> want to run your programs compiled by 4.3 :-/  Not something we'd like to 
> demand.

I changed the title just for emphasis.

I think that we can't ship 4.3.0 if signal handlers on x86/x86_64
platforms for both Linux and BSD systems will mysteriously (to the users)
fail, and it doesn't matter whose fault it is.


