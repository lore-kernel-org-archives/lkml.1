Return-Path: <linux-kernel-owner+w=401wt.eu-S932680AbYF3VBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680AbYF3VBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756413AbYF3VBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:01:45 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39852 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbYF3VBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:01:45 -0400
Date: Mon, 30 Jun 2008 22:01:42 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #10961] 2.6.26-rc: nfsd hangs for a few sec
Message-ID: <20080630210142.GB20245@csn.ul.ie>
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik> <X8mbwW6K81I.A.PjD.169ZIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <X8mbwW6K81I.A.PjD.169ZIB@albercik>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (29/06/08 20:18), Rafael J. Wysocki didst pronounce:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10961
> Subject		: 2.6.26-rc: nfsd hangs for a few sec
> Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
> Date		: 2008-06-21 12:57 (9 days old)
> References	: http://marc.info/?l=linux-kernel&m=121405308328004&w=4
> 		  http://marc.info/?l=linux-kernel&m=121412880115289&w=4
> Handled-By	: Linus Torvalds <torvalds@linux-foundation.org>
> 		  Mel Gorman <mel@csn.ul.ie>
> 		  Christoph Lameter <clameter@sgi.com>

I still have no useful reaction to this. According to Christoph Hellwig,
this lockup has been appearing since lockdep was introduced but for some
reason is easier to trigger now. It bisected to the two-zonelist changes
but it still looks like a red herring as I cannot see how reclaim has
changed significantly as a result of that patch.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
