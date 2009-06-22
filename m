Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbZFVHw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbZFVHw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 03:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbZFVHwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 03:52:22 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:40534 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZFVHwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 03:52:21 -0400
Subject: Re: [PATCH] Add new TAINT_KSPLICE flag for when a Ksplice update
 has been loaded.
From: Jon Masters <jonathan@jonmasters.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tim Abbott <tabbott@ksplice.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anders Kaseorg <andersk@ksplice.com>,
       Jeffrey B Arnold <jbarnold@ksplice.com>
In-Reply-To: <1245442307.16209.66.camel@laptop>
References: <alpine.DEB.1.10.0906191422460.29844@vinegar-pot.mit.edu>
	 <1245442307.16209.66.camel@laptop>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 22 Jun 2009 03:51:54 -0400
Message-Id: <1245657114.3265.4074.camel@perihelion.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-19 at 22:11 +0200, Peter Zijlstra wrote:
> On Fri, 2009-06-19 at 15:57 -0400, Tim Abbott wrote:
> > Distributions and kerneloops.org have requested that the Ksplice
> > rebootless update system taint the kernel the first time that a
> > Ksplice update is installed, in order to assist with bug triage.
> > 
> > Ksplice uses a new taint flag, TAINT_KSPLICE, displayed as 'K', for
> > this purpose.
> > 
> > We would like to confirm that this use of taint meets with the
> > community's approval and get this taint flag registered in mainline.
> > 
> > Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> 
> Since all of ksplice is still out-of-tree, it seems to me this taint
> should be too.

Respectfully, I disagree.

The thing is, distribution maintainers and others would really benefit
from knowing if this stuff is loaded today, before the possible eventual
addition of ksplice upstream. We already have tainting for non-GPL code
and I don't see us arguing about the fact that the kernel has no non-GPL
code actually shipping in it to cause such taints to get set :)

Jon.


