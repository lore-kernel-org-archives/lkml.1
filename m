Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbZKDPWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbZKDPWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbZKDPWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:22:30 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44795 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225AbZKDPW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:22:29 -0500
Subject: Re: [RFC] Mount point suggestions for cgroup
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: balbir@linux.vnet.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata.rao@in.ibm.com>,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       "menage@google.com" <menage@google.com>,
       Jan Safranek <jsafrane@redhat.com>
In-Reply-To: <20091104081618.GD3560@balbir.in.ibm.com>
References: <20091104063005.GC3560@balbir.in.ibm.com>
	 <20091104154024.0b8f6123.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091104081618.GD3560@balbir.in.ibm.com>
Content-Type: text/plain
Date: Wed, 04 Nov 2009 07:21:57 -0800
Message-Id: <1257348117.31972.4360.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-04 at 13:46 +0530, Balbir Singh wrote:
> The reason I liked /dev/cgroup was because cpusets could be
> mounted at /dev/cpuset or /dev/cgroup/cpuset. My concern with /cgroup
> is that a ls "/" now becomes larger in size. But I'll take your vote
> for it as +1 for /cgroup.

/dev/pts is a decent precedent for doing it under /dev, although it does
deal with actual devices.  cgroups do not.

-- Dave

