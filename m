Return-Path: <linux-kernel-owner+w=401wt.eu-S1750903AbZKIFKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750903AbZKIFKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 00:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbZKIFKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 00:10:33 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:58323 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbZKIFKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 00:10:32 -0500
Date: Mon, 9 Nov 2009 10:35:18 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: libcg-devel <libcg-devel@lists.sourceforge.net>,
       "menage@google.com" <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org,
       Jan Safranek <jsafrane@redhat.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Bharata B Rao <bharata.rao@in.ibm.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
Message-ID: <20091109050517.GA3042@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091104063005.GC3560@balbir.in.ibm.com>
 <20091108170512.GB1372@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091108170512.GB1372@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [2009-11-08 18:05:12]:

> On Wed 2009-11-04 12:00:05, Balbir Singh wrote:
> > Hi, All,
> > 
> > We've been having a discussion as to what would be the right place to
> > mount the cgroup filesystem. Jan has been proactively looking into
> > this. The FHS has no recommendation since cgroup filesystem came in
> > much later.
> > 
> > The options are
> > 
> > 1. /dev/cgroup
> > 2. /cgroup
> > 3. Some place under /sys
> 
> Underr /sys, please. Actually I wonder that it may even belong /proc
> ... It *is* process related, right?
>

We already have /proc/cgroups for showing currently supported
subsystems and /proc/pid/cgroups to show which subsystems/tasks
 

-- 
	Balbir
