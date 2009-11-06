Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbZKFHcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbZKFHcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 02:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbZKFHcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 02:32:10 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:38880 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbZKFHcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 02:32:09 -0500
Date: Fri, 6 Nov 2009 13:02:08 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Jan Safranek <jsafrane@redhat.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       "menage@google.com" <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       containers@lists.linux-foundation.org,
       Bharata B Rao <bharata.rao@in.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
Message-ID: <20091106073208.GA4992@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091104063005.GC3560@balbir.in.ibm.com>
 <4AF1AF68.40704@free.fr>
 <4AF2C000.3020807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4AF2C000.3020807@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jan Safranek <jsafrane@redhat.com> [2009-11-05 13:07:28]:

> On 11/04/2009 05:44 PM, Daniel Lezcano wrote:
> >Balbir Singh wrote:
> >>Hi, All,
> >>
> >>We've been having a discussion as to what would be the right place to
> >>mount the cgroup filesystem. Jan has been proactively looking into
> >>this. The FHS has no recommendation since cgroup filesystem came in
> >>much later.
> >>
> >>The options are
> >>
> >>1. /dev/cgroup
> >>2. /cgroup
> >>3. Some place under /sys
> >>
> >>The problem with (2) is that it is quite non-standard and pollutes the
> >>root directory. (3) requires some basic support to create a directory
> >>for cgroup under /sys. (1) seems the most obvious choice since cpusets
> >>were mounted under /dev/cpuset, but /dev is controlled by udev.
> >>
> >>Given the three choices or any other suggestions, is there a general
> >>preference as to where we can mount it? The goal is to standardize
> >>the mount point (if possible).
> >Why the mount point has to be standardized ?
> >
> 
> The mount point does not need to be set into stone so everybody
> *must* use it. I, as Fedora packager, just need some default place
> where to mount it, so applications which need to create/manage
> groups work without any (potentially dumb) user assistance. 

I see no consensus, there are different approaches people like. I
wonder if we can create an empty directory under /sys/kernel/cgroup,
if so we would have supported the /sys approach. I'll send out a patch
to do the same.


Of
> course, advanced admin can change the settings and move the groups
> anywhere, applications still need to parse /proc/mounts or use
> appropriate library like libcgroup.

Agreed.

-- 
	Balbir
