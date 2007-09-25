Return-Path: <linux-kernel-owner+w=401wt.eu-S1758988AbXIYQKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988AbXIYQKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbXIYQKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:10:44 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42838 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbXIYQKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:10:43 -0400
Subject: Re: [PATCH 24/25] r/o bind mounts: track number of mount writers
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
In-Reply-To: <20070924161555.aad68a72.akpm@linux-foundation.org>
References: <20070920195249.852667D5@kernel>
	 <20070920195320.38C8E20D@kernel>
	 <20070923231713.f81ee0db.akpm@linux-foundation.org>
	 <1190671602.26982.261.camel@localhost>
	 <20070924152532.305ec951.akpm@linux-foundation.org>
	 <1190675137.26982.266.camel@localhost>
	 <20070924161555.aad68a72.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 09:10:39 -0700
Message-Id: <1190736639.26982.279.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 16:15 -0700, Andrew Morton wrote:
> On Mon, 24 Sep 2007 16:05:37 -0700
> Dave Hansen <haveblue@us.ibm.com> wrote:
> 
> > On Mon, 2007-09-24 at 15:25 -0700, Andrew Morton wrote:
> > > hm.  I saw that warning on my 2-way.  It has CONFIG_NR_CPUS=8 so perhaps
> > > the kernel has decided that this machine can possibly have eight CPUs.
> > > 
> > > It's an old super-micro board, doesn't have ACPI.
> > 
> > Well, it's looking like we only set cpu_possible_map from data we find
> > in the MP table, which makes sense.  The only question is how your
> > system gets more than ~8 possible cpus.  Do you have the .config handy?
> 
> http://userweb.kernel.org/~akpm/config-vmm.txt

I've reproduced this.  I'll do more runtime testing with all of the
debugging, CONFIG_CPU_HOTPLUG=y, and NR_CPUS to a high value.  It should
help catch things like this in the future.  

-- Dave

