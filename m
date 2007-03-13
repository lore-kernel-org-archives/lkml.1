Return-Path: <linux-kernel-owner+w=401wt.eu-S1752527AbXCMAio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbXCMAio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 20:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbXCMAio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 20:38:44 -0400
Received: from ozlabs.org ([203.10.76.45]:45234 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbXCMAio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 20:38:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17909.62028.117035.287313@cargo.ozlabs.ibm.com>
Date: Tue, 13 Mar 2007 11:37:32 +1100
From: Paul Mackerras <paulus@samba.org>
To: David Miller <davem@davemloft.net>
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org, ak@suse.com, holt@sgi.com,
       linux-ia64@vger.kernel.org, mpm@selenic.com
Subject: Re: [QUICKLIST 0/6] Arch independent quicklists V1
In-Reply-To: <20070312.155157.74747634.davem@davemloft.net>
References: <20070311020923.19905.49260.sendpatchset@schroedinger.engr.sgi.com>
	<20070312.155157.74747634.davem@davemloft.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:

> I ported this to sparc64 as per the patch below, tested on
> UP SunBlade1500 and 24 cpu Niagara T1000.

Did you see any performance improvement?  We used to have quicklists
on ppc, but I remain to be convinced that they actually help.

Also, I didn't understand why we have to do quicklists to take
advantage of the fact that the pages are in a pristine state when they
are freed.  I thought the whole point of the slab allocator was to be
able to take advantage of that...

Paul.

