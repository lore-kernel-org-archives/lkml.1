Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbYGRWnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbYGRWnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbYGRWm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:42:56 -0400
Received: from outbound-mail-137.bluehost.com ([67.222.39.27]:44821 "HELO
	outbound-mail-137.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754521AbYGRWm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:42:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=TyweZuURnwprJPCUDNI4cu9W+G0gfiZ6YDA86ke3jsP9a6cO/3ifbmcBS5bnEZ0p6QqsxNAN48qNglbPQDg2hKOyvhtl9HNQwav+01wPwi27d5h67qvKwuBO7aJCpFan;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86,pci: detect end_bus_number according to acpi/e820 reserved
Date: Fri, 18 Jul 2008 15:42:42 -0700
User-Agent: KMail/1.9.9
Cc: "Jack Howarth" <howarth@bromo.msbb.uc.edu>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Shaohua Li <shaohua.li@intel.com>
References: <200807180941.09779.yhlu.kernel@gmail.com> <20080718214825.GA8132@bromo.msbb.uc.edu> <86802c440807181527u1e373b2drc72456b33a4bcd76@mail.gmail.com>
In-Reply-To: <86802c440807181527u1e373b2drc72456b33a4bcd76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807181542.42670.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 18, 2008 3:27 pm Yinghai Lu wrote:
> On Fri, Jul 18, 2008 at 2:48 PM, Jack Howarth <howarth@bromo.msbb.uc.edu> 
wrote:
> > YH,
> >  I'll test the new patch shortly. When I do, I'll put back in
> > your debug patches to try to get a complete log with pci=verbose
> > and initcall_debug with PCIEASPM disabled.
>
> tip tree has the two debug patches.
>
> > Hopefully the probing
> > is done in the same general fashion with and without PCIEASPM so
> > we can deduce what exactly is being probed when my MacBook Pro
> > freezes during boot with PCIEASPM enabled. I consider the fact
> > that booting 2.6.26 always freezes the kernel when PCIEASPM
> > is enabled to be the more serious bug (since once Fedora ships
> > 2.6.26 kernels I'll be stuck always building my own).
>
> another laptop : Acer ... suffer this problem too with ASPM...

Yeah, looks like we'll have to be more conservative about enabling ASPM.  
Maybe a whitelist approach would be better...

Jesse
