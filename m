Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbYAXRU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbYAXRU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbYAXRUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 12:20:13 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:44294
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbYAXRUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:20:12 -0500
Date: Thu, 24 Jan 2008 18:19:59 +0100
From: Andrea Arcangeli <andrea@cpushare.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Helmut Grohne <helmut@subdivi.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: PROBLEM: SECCOMP documentation outdated in some arch/*/Kconfig
Message-ID: <20080124171959.GR7141@v2.random>
References: <20080122144156.GA29993@alf.mars> <20080122162156.e62e4285.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122162156.e62e4285.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 04:21:56PM -0800, Randy Dunlap wrote:
> On Tue, 22 Jan 2008 15:41:58 +0100 Helmut Grohne wrote:
> 
> > Hi,
> > 
> > I didn't find out whom to report this bug to and thus report to
> > linux-kernel@vger.kernel.org as described in
> > http://kernel.org/pub/linux/docs/lkml/reporting-bugs.html.
> 
> Andrea cc-ed.
> 
> Helmut, would you care to make a patch that you think should be
> applied to the current kernel source tree?

I'd like to point out CPUShare will soon become an encrypted p2p
virtual ethernet (with mac->internet:port mapping managed by the
server and routed through the buyer node if behind nat) of KVM
machines (using -net tap,fd) so anything will run unmodified
(including non-linux guest) and it can be trivally bridged to extend
the local ethernet. This was forced because despite enormous buyer
(and obviously seller) interest, very few of the buyers are capable of
writing .c and .py software to make the required modifications to
their apps to run on CPUShare (the JtR patch for seccomp was <500lines
but it's still a way too high barrier, especially during this startup
phase). After the switch to KVM, the only requirement to buy CPU power
on CPUShare is to be able to create a livecd, something more people
should be capable of doing.

Given not everyone was happy with seccomp, this would be a good time
to speak again against it, as I wouldn't be objecting its removal (not
from a CPUShare POV at least). I'd personally like seccomp to stay and
to update the Kconfig because I think it can be useful still and it's
the most secure model.
