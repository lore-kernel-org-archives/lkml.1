Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZKDQoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZKDQoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757251AbZKDQoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:44:23 -0500
Received: from mtagate3.de.ibm.com ([195.212.17.163]:39912 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757137AbZKDQoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:44:22 -0500
Message-ID: <4AF1AF68.40704@free.fr>
Date: Wed, 04 Nov 2009 17:44:24 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: libcg-devel <libcg-devel@lists.sourceforge.net>,
       "menage@google.com" <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Jan Safranek <jsafrane@redhat.com>,
       containers@lists.linux-foundation.org,
       Bharata B Rao <bharata.rao@in.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
References: <20091104063005.GC3560@balbir.in.ibm.com>
In-Reply-To: <20091104063005.GC3560@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
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
>
> The problem with (2) is that it is quite non-standard and pollutes the
> root directory. (3) requires some basic support to create a directory
> for cgroup under /sys. (1) seems the most obvious choice since cpusets
> were mounted under /dev/cpuset, but /dev is controlled by udev.
>
> Given the three choices or any other suggestions, is there a general
> preference as to where we can mount it? The goal is to standardize
> the mount point (if possible).
>   
Why the mount point has to be standardized ?

> BTW, the mounting is expected to be done using cgconfigparser present
> in libcgroup.
>   
