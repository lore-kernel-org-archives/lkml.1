Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZDURaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZDURaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbZDURaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:30:03 -0400
Received: from lixom.net ([66.141.50.11]:39153 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbZDURaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:30:00 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Apr 2009 13:30:00 EDT
Date: Tue, 21 Apr 2009 12:25:02 -0500
From: Olof Johansson <olof@lixom.net>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Paul Mackerras <paulus@samba.org>, subrata@linux.vnet.ibm.com,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next <linux-next@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] powerpc/pasemi: Fix no SMP build error
Message-ID: <20090421172502.GA20237@lixom.net>
References: <1239285094.5188.65.camel@subratamodak.linux.ibm.com> <49E8B015.7060808@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E8B015.7060808@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 09:36:37AM -0700, Geoff Levand wrote:
> A non-SMP version of smp_send_stop() is now included in smp.h.
> Remove the unneeded def in the pasemi setup.c.
> 
> Fixes build errors like these when CONFIG_SMP=n:
> 
>   arch/powerpc/platforms/pasemi/setup.c:48: error: redefinition of ???smp_send_stop???
>   include/linux/smp.h:125: error: previous definition of 'smp_send_stop' was here

Thanks for taking care of this.

> Reported-by: subrata@linux.vnet.ibm.com
> Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>


Acked-by: Olof Johansson <olof@lixom.net>


-Olof
