Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbZAGEsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbZAGEsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 23:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbZAGEsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 23:48:46 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:12715 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbZAGEsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 23:48:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KsPxY+PRlIF3NuAIMpH28y0wQ5AvTDR2Mj4Uvc6c2g0VafdlXCacVvx4HHshUST8vp
         UQxN9w1dtF899H6gwg0v8/NntJ9PBZ1XL79gWJMOKWrXG86Up6nwnQwDeXboi3mgtdla
         AX8fDtgdP4m2UjE9c+aBfXvAfwr6vkxnuCMsQ=
Subject: Re: powerpc: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1231303340.14860.61.camel@pasglop>
References: <200901070400.n0740Ore002063@hera.kernel.org>
	 <1231303340.14860.61.camel@pasglop>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 20:48:42 -0800
Message-Id: <1231303722.14442.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 15:42 +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2009-01-07 at 04:00 +0000, Linux Kernel Mailing List wrote:
> > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=156ca2bbf6503a02d7d6829886ce381d572de66e
> > Commit:     156ca2bbf6503a02d7d6829886ce381d572de66e
> > Parent:     8cdd3a9261e8efe36aeb6c708edb76d7e2b5d13f
> > Author:     Harvey Harrison <harvey.harrison@gmail.com>
> > AuthorDate: Tue Jan 6 14:56:23 2009 -0800
> > Committer:  Linus Torvalds <torvalds@linux-foundation.org>
> > CommitDate: Tue Jan 6 18:10:27 2009 -0800
> > 
> >     powerpc: introduce asm/swab.h
> >     
> >     Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> Was this tested ? I see no arch maintainer signed-off here, it appears
> to at least break ppc32, and contains hunks that paulus says were
> explicitely nacked (removing of our ld_* macros) etc...
> 
> Linus, please revert.

Please look a bit closer, it's a pure movement of code out of byteorder.h into swab.h,
no changes whatsoever.

Cheers,

Harvey

