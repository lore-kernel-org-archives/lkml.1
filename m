Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbYG2RXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbYG2RXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYG2RXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:23:16 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:39910 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYG2RXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:23:15 -0400
Subject: Re: s390 hugetlb oops with libhugetlbfs test-suite
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: schwidefsky@de.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       agl@us.ibm.com
In-Reply-To: <20080726034127.GA8338@us.ibm.com>
References: <20080725211035.GA19738@us.ibm.com>
	 <20080726033254.GA3810@us.ibm.com>  <20080726034127.GA8338@us.ibm.com>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 19:22:43 +0200
Message-Id: <1217352163.4829.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-25 at 20:41 -0700, Nishanth Aravamudan wrote:
> Odd, this is the same kernel as last time, which wasn't tainted. The reason for
> the taint is the following:
> 
> ------------[ cut here ]------------
> Badness at drivers/s390/cio/qdio_main.c:1361

Hi,

This was fixed by our qdio developer recently, but the fix is not yet
upstream. However, I doubt that this is related to the hugetlbfs problem.

I was able to reproduce the "Bad page state", with the current libhugetlbfs
development snapshot and your patch for s390. It only happened on machines
with software large page emulation, but we certainly have a problem there.
Thanks for reporting this bug and adding s390 support to libhugetlbfs, I
will look into this problem.

Thanks,
Gerald


