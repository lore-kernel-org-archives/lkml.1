Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbXCTUiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbXCTUiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXCTUiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:38:00 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34881 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752622AbXCTUh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:37:58 -0400
Date: Tue, 20 Mar 2007 21:39:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jeremy@goop.org,
       xen-devel@lists.xensource.com, netdev@vger.kernel.org, mingo@elte.hu,
       Andi Kleen <ak@suse.de>, jbeulich@novell.com,
       virtualization@lists.linux-foundation.org, chrisw@sous-sol.org,
       virtualization@lists.osdl.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, anthony@codemonkey.ws,
       akpm@linux-foundation.org, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [patch 13/26] Xen-paravirt_ops: Consistently
 wrap paravirt ops callsites to make them patchable
Message-ID: <20070320213918.116862be@lxorguk.ukuu.org.uk>
In-Reply-To: <20070320202352.GF4286@bingen.suse.de>
References: <20070319.204712.118947830.davem@davemloft.net>
	<m13b40wnrb.fsf@ebiederm.dsl.xmission.com>
	<200703201428.50564.ak@suse.de>
	<m1ircvswzz.fsf@ebiederm.dsl.xmission.com>
	<20070320174159.GA4286@bingen.suse.de>
	<Pine.LNX.4.64.0703200947501.6730@woody.linux-foundation.org>
	<20070320180359.GB4286@bingen.suse.de>
	<Pine.LNX.4.64.0703201022040.6730@woody.linux-foundation.org>
	<20070320192118.GD4286@bingen.suse.de>
	<Pine.LNX.4.64.0703201145570.6730@woody.linux-foundation.org>
	<20070320202352.GF4286@bingen.suse.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Because that's really the issue: do you want a "pretty" backtrace, or do 
> > you want one that is rock solid but has some crud in it.
> 
> I just want an as exact backtrace as possible. I also think
> that we can make the unwinder robust enough.

Any reason you can't put the exact back trace in "[xxx]" and the ones we
see on the stack which dont look like call trace as ?xxx? It makes the
code a bit trickier but we depend on the quality of traces

Alan
