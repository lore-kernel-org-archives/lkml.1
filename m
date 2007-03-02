Return-Path: <linux-kernel-owner+w=401wt.eu-S1161309AbXCBALc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161309AbXCBALc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 19:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422637AbXCBALc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 19:11:32 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:57625 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161304AbXCBALb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 19:11:31 -0500
Date: Thu, 1 Mar 2007 16:08:08 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Adam Litke <agl@us.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org
Subject: Re: Kernel Oops with shm namespace cleanups
Message-ID: <20070302000808.GE10643@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Adam Litke <agl@us.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	akpm@linux-foundation.org
References: <1172693610.12805.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172693610.12805.16.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 02:13:29PM -0600, Adam Litke wrote:
> Hey.  While testing 2.6.21-rc2 with libhugetlbfs, the shm-fork test case
> causes the kernel to oops.  To reproduce:  Execute 'make check' in the
> latest libhugetlbfs source on a 2.6.21-rc2 kernel with 100 huge pages
> allocated.  Using fewer huge pages will likely also trigger the oops.
> Libhugetlbfs can be downloaded from:
> http://libhugetlbfs.ozlabs.org/snapshots/libhugetlbfs-dev-20070228.tar.gz

Looks like I should grab these testcases for the sake of due diligence
(not to say I intend to alter maintenance style from primarily review,
approval, and bugfixing, not that I've been doing as much of any of those
as I should). To which architectures and/or distributions have the
userspace bits been ported, or otherwise run/tested on? A quick sniff
test on an Altix suggests SLES and/or ia64 may trip up the scripts:
$ su -c "make check"
Password:
         VERSION
	 ./run_tests.sh: line 1: get_hugetlbfs_path: command not found
	 run_tests.sh: unable to find hugetlbfs mountpoint
	 make: *** [check] Error 1


-- wli
