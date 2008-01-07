Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbYAGNyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbYAGNyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 08:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbYAGNyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 08:54:41 -0500
Received: from www.tglx.de ([62.245.132.106]:33803 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961AbYAGNyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 08:54:40 -0500
Date: Mon, 7 Jan 2008 14:53:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, hpa@zytor.com
Subject: Re: [PATCH -mm/x86] revert i386: handle an initrd in highmem (Was
 Re: 2.6.24-rc6-mm1)
In-Reply-To: <20080107135038.GA19568@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.0.99999.0801071453070.31637@localhost.localdomain>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20080107135038.GA19568@linux.vnet.ibm.com>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008, Dhaval Giani wrote:

> Hi Andrew, Ingo, Thomas, Peter,
> 
> x86: revert i386: handle an initrd in highmem
> 
> The patch caused a failure while booting a kexec kernel.
> (http://lkml.org/lkml/2008/1/7/42 has the bisect details.)
> 
> The following patch reverts it.
> 
> Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

Thanks for tracking this down. I'll pull the patch from the x86 git
tree as well.

     tglx
