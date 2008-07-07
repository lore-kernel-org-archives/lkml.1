Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbYGGXIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbYGGXIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 19:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbYGGXIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 19:08:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:40865 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbYGGXH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 19:07:59 -0400
Subject: Re: Multiple MSI
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Dan Williams <dan.j.williams@intel.com>, Martine.Silbermann@hp.com,
       linux-kernel@vger.kernel.org, Michael Ellerman <michaele@au1.ibm.com>
In-Reply-To: <20080707161703.GB7521@colo.lackof.org>
References: <20080703024445.GA14894@parisc-linux.org>
	 <1215055469.21182.70.camel@pasglop> <20080707161703.GB7521@colo.lackof.org>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 09:06:34 +1000
Message-Id: <1215471994.8970.168.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-07 at 10:17 -0600, Grant Grundler wrote:
> The drivers have to deal with the limitations of the HW spec.
> In this case it means they have to know they are getting power of 2
> number of interrupts. I think exposing this in the API is a requirement
> and not optional.

Ugh ?

The number of interrupts isn't what I was talking about, but the
-alignment- was. ie, the driver should make no assumption that the
irq numbers it will obtain will be aligned to a power-of-two.

Cheers,
Ben.


