Return-Path: <linux-kernel-owner+w=401wt.eu-S964832AbXCFVWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832AbXCFVWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965109AbXCFVWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:22:41 -0500
Received: from cantor.suse.de ([195.135.220.2]:55877 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964832AbXCFVWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:22:40 -0500
Date: Tue, 6 Mar 2007 23:21:58 +0100
From: Andi Kleen <ak@suse.de>
To: Dan Hecht <dhecht@vmware.com>
Cc: tglx@linutronix.de, Zachary Amsden <zach@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
Message-ID: <20070306222157.GJ22829@bingen.suse.de>
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net> <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu> <20070306084647.GA16280@elte.hu> <45ED2C82.3080008@vmware.com> <1173178774.24738.311.camel@localhost.localdomain> <45EDD82F.90204@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EDD82F.90204@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I believe this was just a quick fix in response to Ingo breaking the VMI 
> build yesterday by disabling NO_IDLE_HZ on us.  There is no technical 
> reason why NO_IDLE_HZ=y can't coexist with NO_HZ.

Well it's nasty that you force NO_IDLE_HZ on all of paravirt ops users.
I think the right solution is to make VMI depend on (not select) NO_IDLE_HZ
until you can fix your code to work with dynticks properly.

-Andi
