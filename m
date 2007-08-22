Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbXHVMWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbXHVMWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 08:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758192AbXHVMV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 08:21:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758180AbXHVMV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 08:21:56 -0400
Date: Wed, 22 Aug 2007 15:15:47 +0200
From: Andi Kleen <ak@suse.de>
To: Avi Kivity <avi@qumranet.com>
Cc: Andi Kleen <ak@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
Message-ID: <20070822131547.GS32640@bingen.suse.de>
References: <46CBC842.4070100@vmware.com> <46CBCADF.2070400@qumranet.com> <1187763956.6174.48.camel@localhost.localdomain> <20070822103545.GG2642@bingen.suse.de> <46CC0719.2080103@qumranet.com> <20070822110810.GO32640@bingen.suse.de> <46CC0EAF.3000805@qumranet.com> <20070822112352.GQ32640@bingen.suse.de> <46CC2766.7020602@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CC2766.7020602@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Ah.  But that's mostly modules, so real in-core changes should be very 

Yes that's the big difference. Near all paravirt ops are concentrated
on the core kernel, but this one affects lots of people.

And why "but"? -- modules are as important as the core kernel. They're
not second citizens.

-Andi
