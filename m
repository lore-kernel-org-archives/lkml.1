Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYGEN1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYGEN1j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 09:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbYGEN1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 09:27:31 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58916 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbYGEN1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 09:27:30 -0400
Date: Sat, 5 Jul 2008 07:27:28 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: linux-pci@vger.kernel.org
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Dan Williams <dan.j.williams@intel.com>, Martine.Silbermann@hp.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Michael Ellerman <michael@ellerman.id.au>
Subject: Re: Multiple MSI
Message-ID: <20080705132728.GO14894@parisc-linux.org>
References: <20080703024445.GA14894@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703024445.GA14894@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 08:44:46PM -0600, Matthew Wilcox wrote:
> At the moment, devices with the MSI-X capability can request multiple
> interrupts, but devices with MSI can only request one.  This isn't an
> inherent limitation of MSI, it's just the way that Linux currently
> implements it.  I intend to lift that restriction, so I'm throwing out
> some ideas that I've had while looking into it.

Here's some code.  It's four patches, the first two are to the PCI MSI
code, the third is for the AHCI driver and the fourth is for the x86-64
interrupt code.

It's had some light testing; no performance testing yet.  I'd value some
review.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
