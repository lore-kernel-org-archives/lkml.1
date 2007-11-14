Return-Path: <linux-kernel-owner+w=401wt.eu-S1764147AbXKNTsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764147AbXKNTsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760502AbXKNTs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:48:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58667
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754110AbXKNTs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:48:26 -0500
Date: Wed, 14 Nov 2007 11:48:19 -0800 (PST)
Message-Id: <20071114.114819.97786038.davem@davemloft.net>
To: andi@firstfloor.org
Cc: hch@infradead.org, paulus@samba.org, akpm@linux-foundation.org,
       gregkh@suse.de, mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       perfmon@napali.hpl.hp.com, perfmon2-devel@lists.sourceforge.net,
       ospat-devel@cs.utk.edu, ptools-perfapi@cs.utk.edu
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
From: David Miller <davem@davemloft.net>
In-Reply-To: <p734pfp6lyp.fsf@bingen.suse.de>
References: <18234.53558.883970.87414@cargo.ozlabs.ibm.com>
	<20071114110009.GA17833@infradead.org>
	<p734pfp6lyp.fsf@bingen.suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Wed, 14 Nov 2007 13:38:38 +0100

> At least for x86 and I suspect some 1other architectures we don't
> initially need a syscall at all for this. There is an instruction
> RDPMC who can read a performance counter just fine. It is also much
> faster and generally preferable for the case where a process measures
> events about itself. In fact it is essential for one of the use cases
> I would like to see perfmon used (replacement of RDTSC for cycle
> counting) 

I wouldn't even want to use a syscall for something like
that on Sparc, I'd rather give this a dedicated software
trap so that I can code it completely in assembler.
