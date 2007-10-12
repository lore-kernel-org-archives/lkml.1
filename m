Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbXJLBYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbXJLBYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 21:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbXJLBXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 21:23:53 -0400
Received: from ozlabs.org ([203.10.76.45]:36949 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbXJLBXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 21:23:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18190.52379.97647.468384@cargo.ozlabs.ibm.com>
Date: Fri, 12 Oct 2007 11:23:39 +1000
From: Paul Mackerras <paulus@samba.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       lethal@linux-sh.org, kyle@parisc-linux.org, grundler@parisc-linux.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] powerpc: Switch to generic WARN_ON()/BUG_ON()
In-Reply-To: <20071011171413.GC10877@lixom.net>
References: <20071011171211.GB10877@lixom.net>
	<20071011171413.GC10877@lixom.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson writes:

> Not using the ppc-specific WARN_ON/BUG_ON constructs actually saves about
> 4K text on a ppc64_defconfig. The main reason seems to be that prepping
> the arguments to the conditional trap instructions is more work than
> just doing a compare and branch.

It might be more instructions but it takes fewer cycles, I would
expect.  Do you have the actual instruction sequences to compare?

Paul.
