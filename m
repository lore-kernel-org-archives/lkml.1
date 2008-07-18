Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbYGRW1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbYGRW1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbYGRW1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:27:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:19757 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbYGRW1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:27:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qNHpLluNzN41Mi4EnGut2T0Hx8+zngw+jPHKLzBshncxsPF2LDDpbTIfAljDwEHabc
         RkRo4Wquo00jsX14VGssB4rUxnods1LmFxEe3rKvIsKBB1J0rGBHConkZzBn6FUjystv
         uQT8Gqbr/vJVMf6DhY3pjrF0BA+fOu4RgPQ3Y=
Message-ID: <86802c440807181527u1e373b2drc72456b33a4bcd76@mail.gmail.com>
Date: Fri, 18 Jul 2008 15:27:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: [PATCH] x86,pci: detect end_bus_number according to acpi/e820 reserved
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080718214825.GA8132@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807180941.09779.yhlu.kernel@gmail.com>
	 <200807181322.37500.yhlu.kernel@gmail.com>
	 <20080718214825.GA8132@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 2:48 PM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> YH,
>  I'll test the new patch shortly. When I do, I'll put back in
> your debug patches to try to get a complete log with pci=verbose
> and initcall_debug with PCIEASPM disabled.
tip tree has the two debug patches.

> Hopefully the probing
> is done in the same general fashion with and without PCIEASPM so
> we can deduce what exactly is being probed when my MacBook Pro
> freezes during boot with PCIEASPM enabled. I consider the fact
> that booting 2.6.26 always freezes the kernel when PCIEASPM
> is enabled to be the more serious bug (since once Fedora ships
> 2.6.26 kernels I'll be stuck always building my own).

another laptop : Acer ... suffer this problem too with ASPM...

YH
