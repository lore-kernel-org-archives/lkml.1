Return-Path: <linux-kernel-owner+w=401wt.eu-S1767435AbXCIRZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767435AbXCIRZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 12:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767436AbXCIRZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 12:25:22 -0500
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:4055 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767429AbXCIRZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 12:25:20 -0500
Date: Fri, 9 Mar 2007 18:23:55 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Moore, Robert" <robert.moore@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Chuck Ebbert <cebbert@redhat.com>, Rudolf Marek <r.marek@assembler.cz>,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-Id: <20070309182355.d1845962.khali@linux-fr.org>
In-Reply-To: <45F13965.2030709@linux.intel.com>
References: <20070302220454.a0c66d04.khali@linux-fr.org>
	<B28E9812BAF6E2498B7EC5C427F293A402021B07@orsmsx415.amr.corp.intel.com>
	<20070309071855.GA5148@ucw.cz>
	<20070309112420.42420cf2.khali@linux-fr.org>
	<45F13965.2030709@linux.intel.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

On Fri, 09 Mar 2007 13:39:33 +0300, Alexey Starikovskiy wrote:
> Jean Delvare wrote:
> > I can only second Pavel's wish here. This would be highly convenient
> > for OS developers to at least know which resources are accessed by AML
> > and SMM. Without this information, we can never be sure that OS-level
> > code won't conflict with ACPI or SMM.
>
> BIOS vendors are not required to support latest and greatest ACPI spec. 
> So even if some future spec version
> will include this ports description, we will still have majority of 
> hardware not exporting it...

Your reasoning is amazing. So we should refrain from proposing any
improvement which we aren't certain 100% of the systems will support
tomorrow? Then let's all stay away from our keyboards forever, as the
evolution of computer technology is based on exactly that -
improvements which not all systems implement.

It's friday evening, let's have some more for fun. With a similar
logic, ten years ago we'd have come up with the following conclusions:

The majority of computers have a single CPU, there is no point in
adding SMP support to Linux.

Let's not add a new instruction set in our next CPU family. The
majority of systems will not implement it so it will be useless anyway.

There's no point in supporting PnP in Linux, there are a majority of
legacy ISA cards out there which do not support it anyway!

See my point? Just because not every hardware out there supports a
given standard doesn't make that standard necessarily useless.

Just make the next version of ACPI better than the previous one (not
necessarily a challenge) and everyone will embrace it.

-- 
Jean Delvare
