Return-Path: <linux-kernel-owner+w=401wt.eu-S932952AbXA2Ia1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952AbXA2Ia1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 03:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933268AbXA2Ia1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 03:30:27 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52224 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932952AbXA2Ia0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 03:30:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>, ebiederm@xmission.com, jeff@garzik.org,
       greg@kroah.com, tony.luck@intel.com, grundler@parisc-linux.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, kyle@parisc-linux.org,
       linuxppc-dev@ozlabs.org, brice@myri.com, shaohua.li@intel.com,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH 0/6] MSI portability cleanups
References: <m1hcuaohqj.fsf@ebiederm.dsl.xmission.com>
	<20070128.153707.30184351.davem@davemloft.net>
	<m1tzyammv0.fsf@ebiederm.dsl.xmission.com>
	<20070128.212554.23015561.davem@davemloft.net>
	<1170050737.26655.233.camel@localhost.localdomain>
Date: Mon, 29 Jan 2007 01:28:39 -0700
In-Reply-To: <1170050737.26655.233.camel@localhost.localdomain> (Benjamin
	Herrenschmidt's message of "Mon, 29 Jan 2007 17:05:37 +1100")
Message-ID: <m11wleme2w.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> That is to make Eric's code itself cope with the HV case. I'm a bit at
> loss right now as how precisely to do it. I need to spend more time
> staring at the code after Eric latest patches rather than the patches
> themselves I suppose :-) (Eric, they don't apply out of the box on
> current git, they are against -mm ?).

Current git + gregkh-pci (Which has a couple of Michaels patches).
With current git the only problem should be context around msi_lookup_irq
which changes between the two.  But in this case the context around
an entire function being deleted doesn't matter.

Eric
