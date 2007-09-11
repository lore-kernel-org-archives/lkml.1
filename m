Return-Path: <linux-kernel-owner+w=401wt.eu-S1761946AbXIKPyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761946AbXIKPyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 11:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbXIKPy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 11:54:29 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:23212 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbXIKPy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 11:54:28 -0400
Date: Tue, 11 Sep 2007 08:53:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: vatsa@linux.vnet.ibm.com
Cc: Cedric Le Goater <clg@fr.ibm.com>, Paul Menage <menage@google.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, Jan Engelhardt <jengelh@computergmbh.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Hookup group-scheduler with task container
 infrastructure
Message-Id: <20070911085301.ca3a00e4.randy.dunlap@oracle.com>
In-Reply-To: <20070911155119.GE16222@linux.vnet.ibm.com>
References: <20070910171049.GA16048@linux.vnet.ibm.com>
	<Pine.LNX.4.64.0709101903220.5368@fbirervta.pbzchgretzou.qr>
	<20070910172334.GB19100@linux.vnet.ibm.com>
	<20070910102259.dc45a481.akpm@linux-foundation.org>
	<20070910174649.GA16222@linux.vnet.ibm.com>
	<b647ffbd0709101537l9af4dc8x743b25c96e0f5235@mail.gmail.com>
	<6599ad830709101545s66fd338dob6932407db4e1002@mail.gmail.com>
	<46E641C1.8000808@fr.ibm.com>
	<20070911082243.9433c528.randy.dunlap@oracle.com>
	<20070911155119.GE16222@linux.vnet.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 21:21:19 +0530 Srivatsa Vaddagiri wrote:

> On Tue, Sep 11, 2007 at 08:22:43AM -0700, Randy Dunlap wrote:
> > That looks odd, like it's a filesystem.
> > What does cfs really mean?
> 
> cfs = completely fair scheduler :)
> 
> In this thread, we are talking of hooking the cfs cpu scheduler with the
> task-container framework in -mm tree, so that the scheduler can deal
> with groups of tasks rather than just tasks, while handling fairness of
> cpu allocation.
> 
> I agree "cfs" control subsystem does look odd a bit here. "cpu" control
> subsystem seems better.

Thanks.  I agree that using "cpu" is better.  I.e., don't tie it
to a particular scheduler name.  It would just need to change the
next time we have a new scheduler.  ;)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
