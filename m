Return-Path: <linux-kernel-owner+w=401wt.eu-S1761646AbXJYEHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbXJYEHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 00:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbXJYEGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 00:06:53 -0400
Received: from colo.lackof.org ([198.49.126.79]:36431 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbXJYEGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 00:06:53 -0400
Date: Wed, 24 Oct 2007 22:06:36 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: How to debug complete kernel lock-ups
Message-ID: <20071025040636.GA3608@colo.lackof.org>
References: <471E1D3A.8000705@free.fr> <471F0DB4.1080709@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471F0DB4.1080709@free.fr>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 11:17:40AM +0200, John Sigler wrote:
...
> I've tested with a vanilla 2.6.22.10 kernel (no PREEMPT_RT patch).
> That system also locks up and remains completely unresponsive (I can't open 
> new ssh sessions, the system won't answer ICMP echo requests).
>
> How do driver writers deal with complete kernel hangs?

Use different HW. Both IA64 and PARISC gives useful diagnostics
when the machine has a hard crash (MCA or HPMC respectively). I'll bet
PPC does too on the POWER machines.

Maybe a newer x86 machine can provide some MCE data as well?

Otherwise it's what gregkh said...not the "we slowly go crazy"
part. :) Well, sometimes. :)

BTW, getting PCI bus traces would be quite helpful in this case.
It'll give you clear data as to whether the devices are being programmed
as expected (also to rule out chipset/Host bus controller issues) and
whether they are responding as expected (maybe something else dies
when they do).

hth,
grant

hth,
grant
