Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZENJ3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZENJ3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 05:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbZENJ3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 05:29:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58779 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbZENJ3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 05:29:11 -0400
Date: Thu, 14 May 2009 11:29:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       Arve Hj?nnev?g <arve@android.com>, linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
Message-ID: <20090514092909.GG1365@ucw.cz>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com> <alpine.DEB.1.10.0905121708470.14226@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905121708470.14226@qirst.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> While we are at it: Could we get rid of the name "Out of Memory" and stop
> printing texts to that effect? What we call an OOM is a failure to
> perform memory reclaim or we are running out of reserves due
> to not being able to run reclaim. Mostly this is due to OS internal issues
> having nothing to do actual amounts of memory available.

It can be 'low on memory' if you play with mlock() a bit. 

It is out of memory if you run out of swap (or have no swap to begin with).

I believe message is often correct. What message would you suggest?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
