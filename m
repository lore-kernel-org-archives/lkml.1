Return-Path: <linux-kernel-owner+w=401wt.eu-S1762512AbXEYPUC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762512AbXEYPUC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 11:20:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbXEYPTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 11:19:54 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38799 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbXEYPTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 11:19:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@suse.de>
Cc: Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@NineX.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       ninex@o2.pl, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
References: <20070514093829.377e04bc@osprey.hogchain.net>
	<m18xbrnyxi.fsf@ebiederm.dsl.xmission.com>
	<20070514160005.627435e3@osprey.hogchain.net>
	<m1odkmmft4.fsf@ebiederm.dsl.xmission.com>
	<20070515212200.517fcba2@osprey.hogchain.net>
	<m14pmcmz8r.fsf@ebiederm.dsl.xmission.com>
	<20070516185225.3f3ac082@osprey.hogchain.net>
	<m1sl9wl28m.fsf@ebiederm.dsl.xmission.com>
	<20070522204103.134bf5a2@osprey.hogchain.net>
	<m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
	<20070525052032.GB9386@suse.de>
Date: Fri, 25 May 2007 09:17:35 -0600
In-Reply-To: <20070525052032.GB9386@suse.de> (Greg KH's message of "Thu, 24
	May 2007 22:20:32 -0700")
Message-ID: <m1myztaq5s.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> Originally I would have thought this would be a good idea, but now that
> Vista is out, which supports MSI, I don't think we are going to need
> this in the future.  All new chipsets should support MSI fine and this
> table will only grow in the future, while the blacklist should not need
> to have many new entries added to it.
>
> So I don't think this is a good idea, sorry.

- The current situation is broken
- In spec hardware does not require MSI to generate interrupts
  Which leaves enabling MSI optional.

Do you have a better idea to solve the current brokenness?

MSI appears to have enough problems that enabling it in a kernel
that is supposed to run lots of different hardware (like a distro
kernel) is a recipe for disaster.

Eric
