Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbYKUIFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbYKUIFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbYKUIFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:05:04 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:37300 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbYKUIFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:05:03 -0500
Date: Fri, 21 Nov 2008 15:54:54 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Valdis.Kletnieks@vt.edu
Cc: nishimura@mxp.nes.nec.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       penguin-kernel@i-love.sakura.ne.jp, linux-kernel@vger.kernel.org
Subject: Re: Random freeze (Re: mmotm 2008-11-19-02-19 uploaded)
Message-Id: <20081121155454.a376d737.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <5539.1227244998@turing-police.cc.vt.edu>
References: <200811200609.mAK69ZbZ053438@www262.sakura.ne.jp>
	<4401.1227222347@turing-police.cc.vt.edu>
	<20081120152054.2f757251.akpm@linux-foundation.org>
	<5539.1227244998@turing-police.cc.vt.edu>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 21 Nov 2008 00:23:18 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 20 Nov 2008 15:20:54 PST, Andrew Morton said:
> 
> > The traditional cause of the above trace is that someone mucked up the
> > block/driver/irq-routing layer and we lost an IO completion.
> 
> Yes, that would explain all the symptoms and tracebacks - everybody comes
> to a screeching halt the next time they try to go to disk, while the actual
> disk drive is showing zero activity.
> 
> > It's also of course possible (but less common) that someone mucked up
> > the VFS.  It would be interesting to revert
> > do_mpage_readpage-dont-submit-lots-of-small-bios-on-boundary.patch.
> 
> I'm seeing an MTBF of about 2-3 hours when actually applying an I/O load to the
> system.  I'll try reverting that patch, and if it survives an entire day or
> two it will be pretty strong circumstantial evidence that patch is the culprit...
> 
Just FYI, I had seen similar errors with recent mmotms,
but current mmotm(2008-11-20-17-03) seems more stable in my environment.


Thanks,
Daisuke Nishimura.
