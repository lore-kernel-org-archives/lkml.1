Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbXIKPlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbXIKPlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 11:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbXIKPlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 11:41:05 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33798 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbXIKPlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 11:41:04 -0400
Date: Tue, 11 Sep 2007 21:21:19 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Paul Menage <menage@google.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, Jan Engelhardt <jengelh@computergmbh.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Hookup group-scheduler with task container infrastructure
Message-ID: <20070911155119.GE16222@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070910171049.GA16048@linux.vnet.ibm.com> <Pine.LNX.4.64.0709101903220.5368@fbirervta.pbzchgretzou.qr> <20070910172334.GB19100@linux.vnet.ibm.com> <20070910102259.dc45a481.akpm@linux-foundation.org> <20070910174649.GA16222@linux.vnet.ibm.com> <b647ffbd0709101537l9af4dc8x743b25c96e0f5235@mail.gmail.com> <6599ad830709101545s66fd338dob6932407db4e1002@mail.gmail.com> <46E641C1.8000808@fr.ibm.com> <20070911082243.9433c528.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070911082243.9433c528.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 08:22:43AM -0700, Randy Dunlap wrote:
> That looks odd, like it's a filesystem.
> What does cfs really mean?

cfs = completely fair scheduler :)

In this thread, we are talking of hooking the cfs cpu scheduler with the
task-container framework in -mm tree, so that the scheduler can deal
with groups of tasks rather than just tasks, while handling fairness of
cpu allocation.

I agree "cfs" control subsystem does look odd a bit here. "cpu" control
subsystem seems better.

-- 
Regards,
vatsa
