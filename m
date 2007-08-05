Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbXHEFAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbXHEFAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 01:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbXHEFAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 01:00:40 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:61555 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbXHEFAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 01:00:39 -0400
Date: Sun, 5 Aug 2007 08:00:33 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, riku.seppala@kymp.net,
       Andy Whitcroft <apw@shadowen.org>, Jeff Garzik <jeff@garzik.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Oops in 2.6.23-rc1-git9, arch/x86_64/pci/k8-bus.c::fill_mp_bus_to_cpumask()
Message-ID: <20070805050032.GA4960@rhun.haifa.ibm.com>
References: <46B3A7BB.9000102@redhat.com> <200708041130.42038.ak@suse.de> <20070804093222.f0d7f3c7.akpm@linux-foundation.org> <200708050140.49590.ak@suse.de> <20070805041531.GX25771@rhun.ibm.com> <86802c440708042133u67e61826wc783c97822e4cde1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440708042133u67e61826wc783c97822e4cde1@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 09:33:58PM -0700, Yinghai Lu wrote:

> I hope we can use .node and .iommu in pci_bus...

pci_bus is shared between different architectures, and not all
architectures need .node and .iommu. Why is this better than using the
(arch specific) ->sysdata?

Cheers,
Muli
