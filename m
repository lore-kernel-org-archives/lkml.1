Return-Path: <linux-kernel-owner+w=401wt.eu-S1760268AbXI0WRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760268AbXI0WRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 18:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758673AbXI0WR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 18:17:26 -0400
Received: from styx.suse.cz ([82.119.242.94]:35836 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757326AbXI0WRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 18:17:25 -0400
Date: Fri, 28 Sep 2007 00:17:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@shadowen.org, vagabon.xyz@gmail.com, linux-kernel@vger.kernel.org,
       kamalesh@linux.vnet.ibm.com
Subject: Re: 2.6.23-rc8-mm1 -- powerpc link failure
In-Reply-To: <20070927151317.67cac358.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709280015260.7567@jikos.suse.cz>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
 <20070925134653.GB8447@shadowen.org> <Pine.LNX.4.64.0709251715530.7567@jikos.suse.cz>
 <20070927120308.GJ2213@shadowen.org> <Pine.LNX.4.64.0709271408170.7567@jikos.suse.cz>
 <20070927151317.67cac358.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007, Andrew Morton wrote:

> > +extern void arch_randomize_brk(void);
> >  #include "../../../fs/binfmt_elf.c" 
> Is this sinful extern-decl-in-C acually needed?

Some time passed since I have written the patch, but I remember that this 
was needed, otherwise under some circumstances the build failed, but I 
don't remember details ... I will try to look at it more in a while.

But it definitely was needed to work with that horrible 
include-huge-c-file-from-another-one.

Thanks,

-- 
Jiri Kosina
SUSE Labs
