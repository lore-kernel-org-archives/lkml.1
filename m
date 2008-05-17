Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbYEQSr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbYEQSr0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 14:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbYEQSrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 14:47:18 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:37719 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753608AbYEQSrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 14:47:17 -0400
Date: Sat, 17 May 2008 14:46:26 -0400
From: Theodore Tso <tytso@mit.edu>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Keith Packard <keithp@keithp.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       bugme-daemon@bugzilla.kernel.org, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: [Bug 10732] REGRESSION: 2.6.26-rc2-git4: X server failed start
	onX61s laptop
Message-ID: <20080517184626.GA16496@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Gabriel C <nix.or.die@googlemail.com>,
	Keith Packard <keithp@keithp.com>,
	"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>,
	"Siddha, Suresh B" <suresh.b.siddha@intel.com>,
	bugme-daemon@bugzilla.kernel.org, airlied@linux.ie,
	"Barnes, Jesse" <jesse.barnes@intel.com>
References: <E1JxGth-0001te-S4@closure.thunk.org> <924EFEDD5F540B4284297C4DC59F3DEE01119AFE@orsmsx423.amr.corp.intel.com> <20080517154131.GA7651@mit.edu> <924EFEDD5F540B4284297C4DC59F3DEE01119B07@orsmsx423.amr.corp.intel.com> <1211047916.27447.314.camel@koto.keithp.com> <482F24C6.2050705@frugalware.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482F24C6.2050705@frugalware.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2008 at 08:32:38PM +0200, Gabriel C wrote:
> > 
> > Which repository is commit 1c12c4cf in?
> 
> 
> It is in linus-git tree , http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1c12c4cf9411eb130b245fa8d0fbbaf989477c7b
> 

...post 2.6.26-rc2-git3.  For Linux kernels 2.6.26-rc2-git4 and
newer, you need to revert this commit or the X Server shipped with
Ubuntu Gutsy will die horribly when run on an X61s laptop with the
Intel 965GM video chipset.

So the question is what's the right fix to keep the kernel compatible
with the X server, besides just reverting the commit entirely?

					- Ted
