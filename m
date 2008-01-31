Return-Path: <linux-kernel-owner+w=401wt.eu-S933762AbYAaQag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762AbYAaQag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760941AbYAaQa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:30:27 -0500
Received: from ns1.suse.de ([195.135.220.2]:37486 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758522AbYAaQaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:30:24 -0500
Date: Thu, 31 Jan 2008 17:30:22 +0100
From: Andi Kleen <ak@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: huang ying <huang.ying.caritas@gmail.com>,
       "Huang, Ying" <ying.huang@intel.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86: add executable mapping support to ioremap
Message-ID: <20080131163022.GD25989@bingen.suse.de>
References: <1201764967.12950.25.camel@caritas-dev.intel.com> <alpine.LFD.1.00.0801311324270.9204@apollo.tec.linutronix.de> <851fc09e0801310522s2d690c3ejef661e5ce6847f73@mail.gmail.com> <alpine.LFD.1.00.0801311720280.9204@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801311720280.9204@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is nothing to fix. It works on virtual addresses. 
> 
> The __pa() in change_page_attr_addr() is only used to check for the
> high alias mapping of the kernel, but the call to change_page_attr
> uses the virtual address.

But __pa() doesn't work for ioremap ...

huang is completely right.

-Andi
