Return-Path: <linux-kernel-owner+w=401wt.eu-S1760904AbXIXXQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904AbXIXXQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 19:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758257AbXIXXQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 19:16:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53646 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757517AbXIXXQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 19:16:04 -0400
Date: Mon, 24 Sep 2007 16:15:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 24/25] r/o bind mounts: track number of mount writers
Message-Id: <20070924161555.aad68a72.akpm@linux-foundation.org>
In-Reply-To: <1190675137.26982.266.camel@localhost>
References: <20070920195249.852667D5@kernel>
	<20070920195320.38C8E20D@kernel>
	<20070923231713.f81ee0db.akpm@linux-foundation.org>
	<1190671602.26982.261.camel@localhost>
	<20070924152532.305ec951.akpm@linux-foundation.org>
	<1190675137.26982.266.camel@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 16:05:37 -0700
Dave Hansen <haveblue@us.ibm.com> wrote:

> On Mon, 2007-09-24 at 15:25 -0700, Andrew Morton wrote:
> > hm.  I saw that warning on my 2-way.  It has CONFIG_NR_CPUS=8 so perhaps
> > the kernel has decided that this machine can possibly have eight CPUs.
> > 
> > It's an old super-micro board, doesn't have ACPI.
> 
> Well, it's looking like we only set cpu_possible_map from data we find
> in the MP table, which makes sense.  The only question is how your
> system gets more than ~8 possible cpus.  Do you have the .config handy?
> 

http://userweb.kernel.org/~akpm/config-vmm.txt
