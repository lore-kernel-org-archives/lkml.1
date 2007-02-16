Return-Path: <linux-kernel-owner+w=401wt.eu-S1946004AbXBPRDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946004AbXBPRDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946010AbXBPRDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:03:43 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:10037 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946004AbXBPRDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:03:42 -0500
Date: Fri, 16 Feb 2007 08:55:46 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Steve Fox <drfickle@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm1
Message-Id: <20070216085546.12248641.randy.dunlap@oracle.com>
In-Reply-To: <1171643832.3039.6.camel@drfickle.rchland.ibm.com>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	<1171643832.3039.6.camel@drfickle.rchland.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 10:37:12 -0600 Steve Fox wrote:

> bl6-13, an x86_64 box listed on test.kernel.org, tripped on this during
> an LTP run, even with
> unify-queue_delayed_work-and-queue_delayed_work_on-fix.patch applied. 
> 
> I'm not sure why the LTP results aren't copied over to TKO, but here's
> the details anyway.
> 
> If someone can give me an idea where to look, I can start a bi-sect if
> it would help.
> 
> kernel BUG at mm/swap.c:469!
> invalid opcode: 0000 [1] SMP 
> last sysfs file: /devices/system/node/node0/cpumap


Try this patch?  http://lkml.org/lkml/2007/2/16/220


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
