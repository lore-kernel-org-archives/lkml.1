Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbXI1CsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbXI1CsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 22:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbXI1CsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 22:48:15 -0400
Received: from thunk.org ([69.25.196.29]:58748 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbXI1CsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 22:48:14 -0400
Date: Thu, 27 Sep 2007 22:47:59 -0400
From: Theodore Tso <tytso@mit.edu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       tomas.winkler@intel.com
Subject: Re: iwl4965 and driver merging policy
Message-ID: <20070928024759.GG8688@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@osdl.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	tomas.winkler@intel.com
References: <1190943567.6158.50.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190943567.6158.50.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 11:39:27AM +1000, Benjamin Herrenschmidt wrote:
> 
> Just a little question in the light of the discussion we had at Kernel
> Summit about merging drivers upstream (and here, I strongly agree with
> Linus, hence my message).
> 
> I just got that new T61 laptop which happens to have an iwl4xxx chip.
> The distro I installed on it (ubuntu) has a driver for it. I suspect
> others do too and most users get it from some random external tree and
> use it.
> 
> Thus my question, why are we about to release 2.6.23 without it ?
> 
> It doesn't seem to pull any depedency nor affect any other external
> piece of code unless I'm missing something, so it's a perfect example of
> what we've been discussing back then: there is just no point not merging
> it at any time right ? :-)

Well, pulling in iwlwifi would require also pulling in the mac80211
subsystem, so it's not quite that simple (although I'm not sure what's
holding back that going into the kernel.)

I had no problem building my personal production kernel by taking
2.6.23-rc8, and doing a git pull from the everything branch in John
Linville's wireless-dev git tree.  It's probably too late to pull it
for 2.6.23-rc8 (although if Linux wanted to do it it's only one git
pull command away :-), but it would be really nice if it could get
merged in for 2.6.24.

						- Ted
