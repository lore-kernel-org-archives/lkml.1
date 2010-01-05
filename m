Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568Ab0AENcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab0AENcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 08:32:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396Ab0AENcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 08:32:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:47432 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0AENcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 08:32:12 -0500
Date: Tue, 5 Jan 2010 05:34:43 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: strict copy_from_user checks issues?
Message-ID: <20100105053443.4a43fc18@infradead.org>
In-Reply-To: <20100105094857.GB5480@osiris.boeblingen.de.ibm.com>
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com>
	<20100104174308.0790757c@infradead.org>
	<20100105094857.GB5480@osiris.boeblingen.de.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010 10:48:57 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> 
> An allyesconfig triggers 52 warnings on s390 (see below). I just
> checked a few but all of them looked like false positives.

hmm I wonder why s390 gcc is so different.... if the s390 gcc isn't
so good at proving things, maybe it's wrong to warn on s390?



> In file included
> from /home2/heicarst/cfu/arch/s390/include/asm/mmu_context.h:13,
> from /home2/heicarst/cfu/arch/s390/include/asm/elf.h:133, from
> include/linux/elf.h:7, from include/linux/module.h:14, from
> drivers/net/tun.c:42: In function 'copy_from_user',
>     inlined from '__tun_chr_ioctl' at drivers/net/tun.c:1124:
> /home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning:
> call to 'copy_from_user_overflow' declared with attribute warning:
> copy_from_user() buffer size is not provably correct

this one is ... interesting btw... I have trouble myself finding where
the check is done... so I can understand gcc having trouble too.





-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
