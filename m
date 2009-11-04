Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbZKDQxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbZKDQxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbZKDQxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:53:53 -0500
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:36312 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712AbZKDQxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:53:53 -0500
Date: Wed, 4 Nov 2009 17:38:20 +0100
From: Gabor Gombas <gombasg@sztaki.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Jan Safranek <jsafrane@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata.rao@in.ibm.com>,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
Message-ID: <20091104163820.GK16736@boogie.lpds.sztaki.hu>
References: <20091104063005.GC3560@balbir.in.ibm.com>
 <20091104154024.0b8f6123.kamezawa.hiroyu@jp.fujitsu.com>
 <20091104081618.GD3560@balbir.in.ibm.com>
 <1257348117.31972.4360.camel@nimitz>
 <4AF1A58E.1020003@redhat.com>
 <20091104160530.GI3560@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104160530.GI3560@balbir.in.ibm.com>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 09:35:30PM +0530, Balbir Singh wrote:

> Yep, but hasn't the pollution already occured with /dev/cpuset today? 
> sysfs would require work for changes to /sys, so do we go with Kame's
> suggestion of /cgroup?

debugfs is already under /sys.

If /dev is not popular, then how about dedicating a location (say
/kernel) as a base for mounting virtual file systems? So cgroups can get
/kernel/cgroup. hugetlbfs is often mounted on /dev/hugepages but that
does not seem to be standardized as well, so it could be the second
citizen under /kernel. configfs could be moved there too. Having a
different rule for every new virtual fs does not seem to be a good
idea...

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
