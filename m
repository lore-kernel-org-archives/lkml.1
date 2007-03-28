Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbXC1E1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbXC1E1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 00:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbXC1E1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 00:27:09 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35566 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbXC1E1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 00:27:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       <daniel.e.wolstenholme@intel.com>
Subject: Re: [PATCH 5/21] MSI: Consolidate MSI-X irq freeing code
References: <20070322105335.33AD5DDF5D@ozlabs.org>
Date: Tue, 27 Mar 2007 22:26:27 -0600
In-Reply-To: <20070322105335.33AD5DDF5D@ozlabs.org> (Michael Ellerman's
	message of "Thu, 22 Mar 2007 21:51:33 +1100")
Message-ID: <m1d52ut2mk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> For the MSI-X case we do exactly the same logic in pci_disable_msix() and
> msi_remove_pci_irq_vectors(), so consolidate them.
>
> msi_remove_pci_irq_vectors() wasn't setting dev->first_msi_irq to 0, but
> I think it should have been, so the consolidated version does.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
