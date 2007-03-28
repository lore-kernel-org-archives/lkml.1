Return-Path: <linux-kernel-owner+w=401wt.eu-S933601AbXC1FbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601AbXC1FbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 01:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbXC1FbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 01:31:16 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37623 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbXC1FbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 01:31:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: michael@ellerman.id.au
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       daniel.e.wolstenholme@intel.com
Subject: Re: [PATCH 9/21] MSI: Expand pci_msi_supported()
References: <20070322105340.53827DDF65@ozlabs.org>
	<m1slbqrn70.fsf@ebiederm.dsl.xmission.com>
	<1175058070.6386.12.camel@concordia.ozlabs.ibm.com>
Date: Tue, 27 Mar 2007 23:30:39 -0600
In-Reply-To: <1175058070.6386.12.camel@concordia.ozlabs.ibm.com> (Michael
	Ellerman's message of "Wed, 28 Mar 2007 15:01:10 +1000")
Message-ID: <m1k5x2rl34.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On another thought if we want to keep the return code we should
probably rename it pci_msi_verify().  Or something like that
so it is clear we are not asking if it is supported a question
with a boolean answer.  But merely verifying that it is supported.

At which point if the verification function fails it would
be expected to return an error code, and we could then be
expected to propagate when we receive it.

Eric
