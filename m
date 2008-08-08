Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbYHHBW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbYHHBW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 21:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYHHBWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 21:22:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44500 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbYHHBWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 21:22:49 -0400
Message-ID: <489B9F17.6000701@kernel.org>
Date: Thu, 07 Aug 2008 18:19:19 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Alok Kataria <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
References: <1218136365.23770.52.camel@alok-dev1>	 <489B6710.9000604@kernel.org>	 <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>	 <489B836A.3050209@goop.org> <489B84EF.6050009@kernel.org>	 <489B8948.6060003@goop.org> <489B8A68.10900@kernel.org>	 <489B8EF4.1030105@goop.org> <1218158045.20178.394.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1218158045.20178.394.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> 
> Using my interplanetary ideas, linking the fixmap at runtime would allow
> optimal placement of the fixmap, any hypervisor areas, vmalloc, and
> pkmap space.  That might allow one to increase the amount of lowmem
> available for direct mapping depending on some platform variables such
> as hypervisor reserved space, physical memory size, APIC present.. those
> aren't known until boot time.  Actually, NCPUs is a good one, since we
> require atomic kmap space dependent on NCPUs, which could be given back
> to linear memory map.
> 
> That might actually be more worthwhile than link time fixed addresses.
> 

Yeah, but that's a huge project.

	-hpa
