Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbYAGRK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbYAGRK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbYAGRKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:10:07 -0500
Received: from www.tglx.de ([62.245.132.106]:44177 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475AbYAGRJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:09:58 -0500
Date: Mon, 7 Jan 2008 17:50:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [PATCH -mm/x86] revert i386: handle an initrd in highmem (Was
 Re: 2.6.24-rc6-mm1)
In-Reply-To: <20080107082237.595b266a.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.0.99999.0801071736320.31637@localhost.localdomain>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20080107135038.GA19568@linux.vnet.ibm.com> <alpine.LFD.0.99999.0801071453070.31637@localhost.localdomain> <20080107145609.GA26652@elte.hu> <20080107082237.595b266a.randy.dunlap@oracle.com>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008, Randy Dunlap wrote:
> On Mon, 7 Jan 2008 15:56:09 +0100 Ingo Molnar wrote:
> > i'm also wondering - what would be the easiest way to integrate kexec 
> > into an automated test environment. If i have a bzImage kernel, is kexec 
> > still supposed to work? Could i for example do a reboot into a new 
> > (kexec-enabled) kernel via kexec in essence?
> 
> My daily/nightly kernel test runs use kexec to boot the test kernel.
> Well, did thru 2.6.24-rc6-git9, but they fail after that.
> Hopefully this patch fixes things.

The patch in question is not in mainline, it's in the mm branch of
x86.git. So the problem in mainline is a different one. Could you
bisect it please ?

Thanks,

	tglx
