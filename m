Return-Path: <linux-kernel-owner+w=401wt.eu-S1761321AbZD2Usw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321AbZD2Usw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757674AbZD2Usm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:48:42 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:57612 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924AbZD2Usl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:48:41 -0400
Date: Wed, 29 Apr 2009 22:50:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 00/15] clean up page aligned data and bss sections
Message-ID: <20090429205047.GB655@uranus.ravnborg.org>
References: <1240938062-3264-1-git-send-email-tabbott@mit.edu> <alpine.DEB.1.10.0904281527210.1623@vinegar-pot.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904281527210.1623@vinegar-pot.mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 03:48:24PM -0400, Tim Abbott wrote:
> On Tue, 28 Apr 2009, Tim Abbott wrote:
> 
> > Here's a new version of the page-aligned section cleanup patch
> > series.  Changes since last version include:
> 
> Sam,
> 
> I am close to having prepared another 4 patch series of similar size to 
> this one for .data.nosave, .data.cacheline_aligned, .data.init_task, and 
> .data.read_mostly.  Along with this page-aligned series and the things 
> that have already been merged, I think these are all of the major 
> cross-architecture patchsets needed for -ffunction-sections (there will 
> remain a good number of section names that only appear on one or two 
> architectures).
> 
> It seems with this set of patches that we're going to bother all the arch 
> maintainers several times if we handle these all completely independently 
> (especially since each patch series has patches that depend on patches 
> from the previous one).  So, I was thinking perhaps we should proceed as 
> follows:
> 
> (1) I send a patch series that does the architecture-independent macro 
> additions as well as the changes for one architecture (say, x86) to use 
> those macros so that they can be reviewed along with the actual usage.
> 
> (2) We get those reviewed and merge at least the architecture-independent 
> patches
> 
> (3) I can send one patch series for each architecture that is just using 
> the macros that have already been merged; then the patch series are nicely 
> decoupled and each arch maintainer only has to ack a single set of changes 
> to their architecture.

Yes - lets get the support stuff applied first and work out from there.
I plan to apply your patches to kbuild-next during the weekend so
we have them in a tree that hits -next.

	Sam
