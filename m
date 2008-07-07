Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYGGD16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYGGD16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 23:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYGGD1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 23:27:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:46045 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbYGGD1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 23:27:49 -0400
Subject: Re: [PATCH 1/4] PCI MSI: Store the number of messages in the
	msi_desc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Michael Ellerman <michael@ellerman.id.au>, linux-pci@vger.kernel.org,
       kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu, tglx@linutronix.de,
       davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <20080707024125.GU14894@parisc-linux.org>
References: <20080705132728.GO14894@parisc-linux.org>
	 <1215264855-4372-1-git-send-email-matthew@wil.cx>
	 <1215396324.19157.14.camel@localhost>
	 <20080707024125.GU14894@parisc-linux.org>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 13:26:50 +1000
Message-Id: <1215401210.8970.50.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-06 at 20:41 -0600, Matthew Wilcox wrote:
> I also think that MSI-X could be improved by changing the interface to
> do away with this msix_entry list passed in -- just allocate the irqs
> consecutively.

Apparently some drivers rely on scattered allocation of MSI-X

Ben.


