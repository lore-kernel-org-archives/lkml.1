Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbXEDGMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbXEDGMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 02:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161608AbXEDGMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 02:12:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38463 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754241AbXEDGMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 02:12:35 -0400
Date: Thu, 3 May 2007 23:12:33 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: kenchen@google.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mm-commits@vger.kernel.org, agl@us.ibm.com,
       hermes@gibson.dropbear.id.au, wli@holomorphy.com, clameter@sgi.com
Subject: Re: + per-cpuset-hugetlb-accounting-and-administration.patch added
 to -mm tree
Message-Id: <20070503231233.4adf560a.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705032233480.24585@chino.kir.corp.google.com>
References: <200705040104.l4414YFR026322@shell0.pdx.osdl.net>
	<20070503183821.b75e8f57.pj@sgi.com>
	<b040c32a0705032149t2a380f82t8145c1d0f8f6736@mail.gmail.com>
	<20070503221206.880b1ec8.pj@sgi.com>
	<Pine.LNX.4.64.0705032233480.24585@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> This information is already exported to userspace through sysfs.  Simply 
> grab the N-mems allowed to your task from /proc/pid/status, cat 
> /sys/devices/system/node/nodeN/meminfo for each N, and add.

Good point.

I don't see how this present patch, to change /proc/meminfo,
can be justified, given this.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
