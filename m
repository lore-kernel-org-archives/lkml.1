Return-Path: <linux-kernel-owner+w=401wt.eu-S1762743AbXHCQjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762743AbXHCQjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 12:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbXHCQj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 12:39:26 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:50016 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbXHCQjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 12:39:25 -0400
Subject: Re: [PATCH] remove hugetlb_instantiation_mutex
From: Adam Litke <agl@us.ibm.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1185779758.4688.177.camel@ymzhang>
References: <1185523069.4688.115.camel@ymzhang>
	 <1185554277.23817.18.camel@localhost.localdomain>
	 <1185779758.4688.177.camel@ymzhang>
Content-Type: text/plain
Date: Fri, 03 Aug 2007 11:39:23 -0500
Message-Id: <1186159163.23817.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 15:15 +0800, Zhang, Yanmin wrote:
> On Fri, 2007-07-27 at 11:37 -0500, Adam Litke wrote:
> > Hey... I am amazed at how quickly you came back with a patch for this :)
> > Thanks for looking at it.  Unfortunately there is one show-stopper and I
> > have some reservations (pun definitely intended) with your approach:
> Thanks for your great comments.

Sorry for such a long delay in responding.  I have been pretty busy
lately.

> > First, your patch does not pass the libhugetlbfs test
> > 'alloc-instantiate-race' which was written to tickle the the race which
> > the mutex was introduced to solve.  Your patch works for shared
> > mappings, but not for the private case.
> My testing about private might not be thorough. Function hugetlb_cow has a race
> for multi-thread to fault on the same private page index. But after I fixed it,
> alloc-instantiate-race still failed.
> 
> I tried to google the source code tarball of libhugetlbfs test suite, but couldn't
> find it. Would you like to send me a copy of the test source codes?

http://libhugetlbfs.ozlabs.org/releases/libhugetlbfs-1.2-pre1.tar.gz

The tarball will contain a test called alloc-instantiate-race.  Make
sure to run it in private and shared mode.  Let me know what you find
out.

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

