Return-Path: <linux-kernel-owner+w=401wt.eu-S933575AbXC1E2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575AbXC1E2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 00:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933581AbXC1E2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 00:28:10 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35580 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933575AbXC1E2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 00:28:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       <daniel.e.wolstenholme@intel.com>
Subject: Re: [PATCH 6/21] MSI: Consolidate BUG_ON()s.
References: <20070322105335.A55D5DDF5F@ozlabs.org>
Date: Tue, 27 Mar 2007 22:27:37 -0600
In-Reply-To: <20070322105335.A55D5DDF5F@ozlabs.org> (Michael Ellerman's
	message of "Thu, 22 Mar 2007 21:51:34 +1100")
Message-ID: <m18xdit2km.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> When freeing MSIs and MSI-Xs, we BUG_ON() if the irq has not been
> freed, ie. if it still has an action. We can consolidate all of these
> BUG_ON()s into msi_free_irqs() as all the code paths lead there almost
> immediately anyway.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
