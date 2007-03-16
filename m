Return-Path: <linux-kernel-owner+w=401wt.eu-S1753015AbXCPH2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbXCPH2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 03:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbXCPH2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 03:28:22 -0400
Received: from 207.47.60.147.static.nextweb.net ([207.47.60.147]:31779 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbXCPH2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 03:28:21 -0400
Subject: Re: [Fastboot] [PATCH 1/1] Allow i386 crash kernels to handle
	x86_64 dumps
From: Ian Campbell <Ian.Campbell@XenSource.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Horms <horms@verge.net.au>, Vivek Goyal <vgoyal@in.ibm.com>,
       fastboot@lists.osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <aec7e5c30703151940x7447abbey80cb6e47250cca58@mail.gmail.com>
References: <1173891609.8591.41.camel@localhost.localdomain>
	 <20070315014635.GC28396@verge.net.au> <20070315045536.GA6766@in.ibm.com>
	 <20070315050754.GB22329@verge.net.au> <20070315054726.GC6766@in.ibm.com>
	 <1173961378.8591.63.camel@localhost.localdomain>
	 <20070315132616.GH6766@in.ibm.com> <20070315234807.GB10861@verge.net.au>
	 <aec7e5c30703151940x7447abbey80cb6e47250cca58@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 07:28:17 +0000
Message-Id: <1174030097.28658.37.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Mar 2007 07:28:21.0034 (UTC) FILETIME=[AC8588A0:01C7679C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 11:40 +0900, Magnus Damm wrote:
> Right. And maybe it's a good idea to make sure that this feature is
> actually supported by kexec-tools before adding code to the kernel?

I sent patches to the fastboot list at the same time I sent these ones
to support differences in the underlying hypervisor architecture in the
tools.

They haven't appeared in the archives yet so I fear they have gone
astray. I'll resend when I get to the office in a bit.

The tools already have support for introducing a SHIM when kexecing
between different architectures (at least in the 64->32 direction if I
understand kexec-tools-testing/purgatory/arch/i386/compat_x86_64.S and
k-t-t.../kexec/arch/i386/compat_x86_64.S correctly). This is really just
an extension of that.

> My gut feeling about this is that you are begging for trouble. The
> kexec/kdump solution is fragile just by itself, and trying to go
> between architectures is just going to be painful.

It works fine under Xen and I think going from 64Xen+32Kernel->32Kernel
makes more sense than going from 64Xen+32Kernel->64Kernel. As I said
originally I'm not so convinced it makes sense in the native case but I
see no reason to outlaw it (people get to keep both pieces etc...)

Ian.

