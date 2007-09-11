Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbXIKP07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbXIKP07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 11:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbXIKP0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 11:26:52 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59137 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbXIKP0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 11:26:51 -0400
Date: Tue, 11 Sep 2007 08:22:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Paul Menage <menage@google.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>, vatsa@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, Jan Engelhardt <jengelh@computergmbh.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Hookup group-scheduler with task container
 infrastructure
Message-Id: <20070911082243.9433c528.randy.dunlap@oracle.com>
In-Reply-To: <46E641C1.8000808@fr.ibm.com>
References: <20070910171049.GA16048@linux.vnet.ibm.com>
	<Pine.LNX.4.64.0709101903220.5368@fbirervta.pbzchgretzou.qr>
	<20070910172334.GB19100@linux.vnet.ibm.com>
	<20070910102259.dc45a481.akpm@linux-foundation.org>
	<20070910174649.GA16222@linux.vnet.ibm.com>
	<b647ffbd0709101537l9af4dc8x743b25c96e0f5235@mail.gmail.com>
	<6599ad830709101545s66fd338dob6932407db4e1002@mail.gmail.com>
	<46E641C1.8000808@fr.ibm.com>
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

On Tue, 11 Sep 2007 09:20:33 +0200 Cedric Le Goater wrote:

> Paul Menage wrote:
> > On 9/10/07, Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> >> On 10/09/2007, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> >>> On Mon, Sep 10, 2007 at 10:22:59AM -0700, Andrew Morton wrote:
> >>>> objection ;)  "cpuctlr" isn't memorable.  Kernel code is write-rarely,
> >>>> read-often.  "cpu_controller", please.  The extra typing is worth it ;)
> >>> Ok! Here's the modified patch (against 2.6.23-rc4-mm1).
> >> as everyone seems to be in a quest for a better name... I think, the
> >> obvious one would be just 'group_sched'.
> >>
> > 
> > But "sched" on its own could refer to CPU scheduling, I/O scheduling,
> > network scheduling, ...
> > 
> > And "group" is more or less implied by the fact that it's in the
> > containers/control groups filesystem.
> 
> "control groups" is the name of your framework. right ?
> 
> > So "group_sched" isn't really all that informative. The name should
> > definitely contain either "cpu" or "cfs".
> 
> "cfs" control group subsystem.

That looks odd, like it's a filesystem.
What does cfs really mean?


> "cfs" looks good enough to identify the subsystem.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
