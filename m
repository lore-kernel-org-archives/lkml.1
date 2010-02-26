Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934725Ab0BZLSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 06:18:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934332Ab0BZLSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 06:18:32 -0500
Date: Fri, 26 Feb 2010 22:18:23 +1100
From: Nick Piggin <npiggin@suse.de>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de, gregkh@novell.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
 due to "e084b - page-allocator: preserve PFN ordering when	__GFP_COLD
 is set"
Message-ID: <20100226111823.GI9738@laptop>
References: <4B796C6D.80800@linux.vnet.ibm.com>
 <20100216112517.GE1194@csn.ul.ie>
 <4B7ACC1E.9080205@linux.vnet.ibm.com>
 <4B7BBCFC.4090101@linux.vnet.ibm.com>
 <20100218114310.GC32626@csn.ul.ie>
 <4B7D664C.20507@linux.vnet.ibm.com>
 <4B7E73BF.5030901@linux.vnet.ibm.com>
 <20100219151934.GA1445@csn.ul.ie>
 <4B82A603.9030602@linux.vnet.ibm.com>
 <4B8693B0.7000804@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8693B0.7000804@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 04:13:52PM +0100, Christian Ehrhardt wrote:
> Christian Ehrhardt wrote:
> FIN)
> So, thats it from my side.
> I look forward to the finalized congestion_wait->zone wait patch however
> this turns out (zone wait is resonable if fixing this symptom or not in
> my opinion).
> But still I have a small amount of hope left that all the data I found here
> might give someone the kick to see whats going on in mm's backstage due to
> that patches.

Hi Christian,

Thanks for doing all this work. I've been looking at a couple of other
regressions while it seemed like you guys were making progress. I can't
seem to reproduce it on my x86-64 system (was anybody able to reproduce
it on x86?)

Anyway I have asked our mainframe guy whether we can set up an
environment.

I agree it is a real problem that really needs to be properly explained.

Thanks,
Nick

