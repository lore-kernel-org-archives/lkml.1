Return-Path: <linux-kernel-owner+w=401wt.eu-S1759605AbYFYQKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605AbYFYQKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYFYQKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:10:38 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61690 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752765AbYFYQKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:10:38 -0400
Date: Wed, 25 Jun 2008 17:10:13 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: noah <noah123@gmail.com>, Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: apic=debug report for 2.6.24 (32-bit) with Intel 3GHz on MSI
 7173
In-Reply-To: <d00698fb0806250853t4e28c69aod1bc039296987ad8@mail.gmail.com>
Message-ID: <Pine.LNX.4.55.0806251702440.22314@cliff.in.clinika.pl>
References: <d00698fb0806250853t4e28c69aod1bc039296987ad8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008, noah wrote:

> ENABLING IO-APIC IRQs
> ..Timer: vector=0x31 apic1=0 pin1=2 apic2=-1 pin=-1
> ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> ...trying to set up timer (IRQ0) through the 8295A ... failed
> ...trying to set up timer as Virtual Wire IRQ ... failed.
> ...trying to set up timer as ExtINT IRQ ... failed. :(
> 
> Booting with noapic works.

 Hmm, that's quite odd.  There's some recent work in this area in
linux-next -- do you have means to try that tree instead?  Did any older
version of Linux work on this board?

 Either way, please send .config and a full log from a bootstrap with the
"noapic" option -- while this piece of code is not reached in such a
scenario, various configuration tables will be dumped at the beginning
regardless and that may give us hints.

  Maciej
