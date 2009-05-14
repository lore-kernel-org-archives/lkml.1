Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbZENU5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbZENU5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZENU45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:56:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48511 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbZENU44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:56:56 -0400
Date: Thu, 14 May 2009 22:56:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       Arve Hj?nnev?g <arve@android.com>, linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
Message-ID: <20090514205600.GA14741@elf.ucw.cz>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com> <alpine.DEB.1.10.0905121708470.14226@qirst.com> <20090514092909.GG1365@ucw.cz> <alpine.DEB.1.10.0905141546040.1381@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905141546040.1381@qirst.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-05-14 15:46:50, Christoph Lameter wrote:
> On Thu, 14 May 2009, Pavel Machek wrote:
> 
> > It can be 'low on memory' if you play with mlock() a bit.
> 
> But that is a reclaim failure becuase of mlocking pages.
> 
> > It is out of memory if you run out of swap (or have no swap to begin with).
> 
> That is a swap config issue.

Well, many machines are _designed_ to run without swap. Swapping on
flash is considered bad.

> > I believe message is often correct. What message would you suggest?
> 
> "Failure to reclaim memory"

That is not a helpful message, I'm afraid. What about

 "Memory allocation failure" ?
 "Out of memory, or failed to allocate memory due to temporary spike"?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
