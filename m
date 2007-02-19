Return-Path: <linux-kernel-owner+w=401wt.eu-S932386AbXBSQKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbXBSQKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 11:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932387AbXBSQKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 11:10:54 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:42676 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386AbXBSQKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 11:10:53 -0500
Subject: Re: 2.6.20-mm1
From: Steve Fox <drfickle@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070216085546.12248641.randy.dunlap@oracle.com>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	 <1171643832.3039.6.camel@drfickle.rchland.ibm.com>
	 <20070216085546.12248641.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Mon, 19 Feb 2007 10:10:51 -0600
Message-Id: <1171901451.3039.25.camel@drfickle.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 08:55 -0800, Randy Dunlap wrote:
> On Fri, 16 Feb 2007 10:37:12 -0600 Steve Fox wrote:
> 
> > bl6-13, an x86_64 box listed on test.kernel.org, tripped on this during
> > an LTP run, even with
> > unify-queue_delayed_work-and-queue_delayed_work_on-fix.patch applied. 
> > 
> > I'm not sure why the LTP results aren't copied over to TKO, but here's
> > the details anyway.
> > 
> > If someone can give me an idea where to look, I can start a bi-sect if
> > it would help.
> > 
> > kernel BUG at mm/swap.c:469!
> > invalid opcode: 0000 [1] SMP 
> > last sysfs file: /devices/system/node/node0/cpumap
> 
> 
> Try this patch?  http://lkml.org/lkml/2007/2/16/220

That fixed it. Thanks.

-- 

Steve Fox
IBM Linux Technology Center

