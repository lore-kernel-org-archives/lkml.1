Return-Path: <linux-kernel-owner+w=401wt.eu-S1751117AbZJGCcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117AbZJGCcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 22:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbZJGCcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 22:32:14 -0400
Received: from thunk.org ([69.25.196.29]:58299 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbZJGCcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 22:32:14 -0400
Date: Tue, 6 Oct 2009 22:31:19 -0400
From: Theodore Tso <tytso@mit.edu>
To: Dave Airlie <airlied@gmail.com>, G@mit.edu
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
Message-ID: <20091007023119.GJ17883@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Dave Airlie <airlied@gmail.com>, G,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <1254864803.6035.25.camel@pasglop> <alpine.LFD.2.01.0910061513510.3432@localhost.localdomain> <21d7e9970910061822i429344amb47b0bceb552abc6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970910061822i429344amb47b0bceb552abc6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 11:22:38AM +1000, Dave Airlie wrote:
> 
> Why don't you just have the kernel version Linux-commitid?
> 
> why keep up the pretense that the 2.6.xx bit means anything outside of release?
> 
> You could just have the tarball generation scripts make it into a 2.6.31 but
> for everyone else we never see it.

The tarball generation scripts for the daily snapshots already set
EXTRAVERSION to -git15, -git16, etc.

So the problem seems to be localized to those users/developers who are
smart enough to use git, and dumb enough not to set
CONFIG_LOCALVERSION_AUTO.  So big of a set this actually is, I can't
say.  Do we have any statistics about how many bug reporters make this
mistake?

						- Ted
