Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbYHHB3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbYHHB3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 21:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYHHB32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 21:29:28 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:43365 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287AbYHHB32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 21:29:28 -0400
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
From: Zachary Amsden <zach@vmware.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Alok Kataria <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <489B9F17.6000701@kernel.org>
References: <1218136365.23770.52.camel@alok-dev1>
	 <489B6710.9000604@kernel.org>
	 <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>
	 <489B836A.3050209@goop.org> <489B84EF.6050009@kernel.org>
	 <489B8948.6060003@goop.org> <489B8A68.10900@kernel.org>
	 <489B8EF4.1030105@goop.org>
	 <1218158045.20178.394.camel@bodhitayantram.eng.vmware.com>
	 <489B9F17.6000701@kernel.org>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 18:28:09 -0700
Message-Id: <1218158889.20178.409.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 18:19 -0700, H. Peter Anvin wrote:
> Zachary Amsden wrote:
> >
> > Using my interplanetary ideas, linking the fixmap at runtime would allow
> > optimal placement of the fixmap, any hypervisor areas, vmalloc, and
> > pkmap space.  That might allow one to increase the amount of lowmem
> > available for direct mapping depending on some platform variables such
> > as hypervisor reserved space, physical memory size, APIC present.. those
> > aren't known until boot time.  Actually, NCPUs is a good one, since we
> > require atomic kmap space dependent on NCPUs, which could be given back
> > to linear memory map.
> >
> > That might actually be more worthwhile than link time fixed addresses.
> >
> 
> Yeah, but that's a huge project.

But it's awesome.

