Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYA1Lcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYA1Lcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 06:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbYA1Lcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 06:32:33 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:1586 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYA1Lcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 06:32:32 -0500
Date: Mon, 28 Jan 2008 11:27:41 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Konrad Rzeszutek <konrad@darnok.org>, linux-kernel@vger.kernel.org,
       greg@kroah.com, dwm@enoyolf.org, darnok@68k.org, pjones@redhat.com,
       konradr@redhat.com, konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com,
       hpa@zytor.com, lenb@kernel.org, mike.anderson@us.ibm.com,
       dwm@austin.ibm.com, arjan@infradead.org, michaelc@cs.wisc.edu
Subject: Re: [PATCH] Add iSCSI iBFT support (v0.4.5)
Message-ID: <20080128112741.GF12910@shadowen.org>
References: <20080125220629.GA25325@andromeda.dapyr.net> <20080126220123.d20dd393.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080126220123.d20dd393.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 10:01:23PM -0800, Andrew Morton wrote:

> >  int __initdata user_defined_memmap = 0;
> 
> checkpatch should have told you that this "= 0" shouldn't be there.  But it
> doesn't.

Ok, this line would be correctly picked up if it was being added by this
author, but this line is in the context only.  We do not blame the current
author for those.

ERROR: do not initialise externals to 0 or NULL
#1: FILE: Z57.c:1:
+int __initdata user_defined_memmap = 0;

> > +	for (pos = (u8 *)hdr; pos < (u8 *)hdr + len; pos ++)
> 
> checkpatch should have caught the " ++" but didn't.  I think it used to. 
> It seems to be going backwards?

Somehow this variant was not covered.  Added to the tests and to the
next version:

ERROR: no space before that '++' (ctx:WxB)
#3: FILE: Z57.c:3:
+       for (pos = (u8 *)hdr; pos < (u8 *)hdr + len; pos ++)

-apw
