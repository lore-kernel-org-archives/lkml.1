Return-Path: <linux-kernel-owner+w=401wt.eu-S965508AbXCFSO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965508AbXCFSO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965560AbXCFSO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:14:56 -0500
Received: from gw.goop.org ([64.81.55.164]:33041 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965508AbXCFSOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:14:51 -0500
Message-ID: <45EDAF99.7080709@goop.org>
Date: Tue, 06 Mar 2007 10:14:49 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 3/8] Use per-cpu variables for GDT, PDA
References: <1173184747.4644.23.camel@localhost.localdomain>	 <1173185592.4644.28.camel@localhost.localdomain>	 <1173185666.4644.30.camel@localhost.localdomain> <1173185734.4644.32.camel@localhost.localdomain>
In-Reply-To: <1173185734.4644.32.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Allocating PDA and GDT at boot is a pain.  Using simple per-cpu
> variables adds happiness (although we need the GDT page-aligned for
> Xen, see later).
>   

Not just Xen.  Apparently it leads to general goodness.

> Finally, we can simply call it "cpu_gdt" rather than enduring the
> superfluous and unnecessarily redundant tautology of "cpu_gdt_table".
>   

Ah, well, at least it isn't excessive.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

    J
