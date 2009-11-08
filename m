Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbZKHRFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbZKHRFQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbZKHRFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:05:15 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53034 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbZKHRFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:05:14 -0500
Date: Sun, 8 Nov 2009 18:05:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: libcg-devel <libcg-devel@lists.sourceforge.net>,
       "menage@google.com" <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org,
       Jan Safranek <jsafrane@redhat.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Bharata B Rao <bharata.rao@in.ibm.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
Message-ID: <20091108170512.GB1372@ucw.cz>
References: <20091104063005.GC3560@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104063005.GC3560@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-11-04 12:00:05, Balbir Singh wrote:
> Hi, All,
> 
> We've been having a discussion as to what would be the right place to
> mount the cgroup filesystem. Jan has been proactively looking into
> this. The FHS has no recommendation since cgroup filesystem came in
> much later.
> 
> The options are
> 
> 1. /dev/cgroup
> 2. /cgroup
> 3. Some place under /sys

Underr /sys, please. Actually I wonder that it may even belong /proc
... It *is* process related, right?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
