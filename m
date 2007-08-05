Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbXHELzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbXHELzc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 07:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbXHELzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 07:55:25 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:33345 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbXHELzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 07:55:24 -0400
Date: Sun, 5 Aug 2007 14:54:57 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       riku.seppala@kymp.net, Andy Whitcroft <apw@shadowen.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH/RFT] finish i386 and x86-64 sysdata conversion
Message-ID: <20070805115457.GD19963@rhun.haifa.ibm.com>
References: <46B3A7BB.9000102@redhat.com> <200708041130.42038.ak@suse.de> <20070804093222.f0d7f3c7.akpm@linux-foundation.org> <200708050140.49590.ak@suse.de> <20070805050410.GB4960@rhun.haifa.ibm.com> <86802c440708042238h39fa1b4ude2836fd9732213b@mail.gmail.com> <20070805075307.GA25890@rhun.haifa.ibm.com> <86802c440708050149u4c0ef4d8j7ea3478b07312525@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440708050149u4c0ef4d8j7ea3478b07312525@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 01:49:57AM -0700, Yinghai Lu wrote:

> Can you change
> pci_scan_bus_with_sysdata(int busno)
> to
> pci_scan_bus_on_node(int bus, struct pci_ops *ops, int node)?

Do you anticipate passing in a different pci_ops or node? 
In any case please remember I am aiming for the minimal "obviously
correc" change for 2.6.23...

> pci_scan_bus_with_sysdata(int busno) make me feel that i need feed one
> sysdata as on param for it.

Yeah, lousy name, but the best I came up with. Runner up was
'x86_pci_scan_bus', which is I think worse?

Cheers,
Muli
