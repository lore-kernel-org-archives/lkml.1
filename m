Return-Path: <linux-kernel-owner+w=401wt.eu-S965379AbXCLJDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965379AbXCLJDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965389AbXCLJDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:03:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58970 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965379AbXCLJDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:03:47 -0400
Date: Mon, 12 Mar 2007 10:03:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <ncunningham@linuxmail.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH 2/3] swsusp: Do not use page flags
Message-ID: <20070312090335.GD8330@elf.ucw.cz>
References: <200703111117.27083.rjw@sisk.pl> <200703111131.07751.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703111131.07751.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Make swsusp use memory bitmaps instead of page flags for marking 'nosave' and
> free pages.  This allows us to 'recycle' two page flags that can be used for other
> purposes.  Also, the memory needed to store the bitmaps is allocated when
> necessary (ie. before the suspend) and freed after the resume which is more
> reasonable.
> 
> The patch is designed to minimize the amount of changes and there are some nice
> simplifications and optimizations possible on top of it.  I am going to
> implement them separately in the future.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Looks ok, but needs to stay in -mm for a while. ACK.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
