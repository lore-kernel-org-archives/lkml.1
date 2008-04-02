Return-Path: <linux-kernel-owner+w=401wt.eu-S1760708AbYDBTHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708AbYDBTHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758686AbYDBTHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:07:18 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:32260 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758813AbYDBTHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:07:16 -0400
Date: Wed, 2 Apr 2008 21:07:13 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, schwidefsky@de.ibm.com,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       Tony Luck <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/3] hugetlbfs: architecture header cleanup
Message-ID: <20080402190713.GB16164@osiris.boeblingen.de.ibm.com>
References: <1207145843.4980.7.camel@localhost.localdomain> <1207146415.4980.11.camel@localhost.localdomain> <1207158176.23710.7.camel@nimitz.home.sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207158176.23710.7.camel@nimitz.home.sr71.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 10:42:56AM -0700, Dave Hansen wrote:
> 
> On Wed, 2008-04-02 at 16:26 +0200, Gerald Schaefer wrote:
> > 
> >  include/asm-ia64/hugetlb.h    |   21 +++++++++++++++++++
> >  include/asm-ia64/page.h       |    6 -----
> >  include/asm-powerpc/hugetlb.h |   35 +++++++++++++++++++++++++++++++
> >  include/asm-powerpc/page_64.h |    7 ------
> >  include/asm-sh/hugetlb.h      |   28 +++++++++++++++++++++++++
> >  include/asm-sparc64/hugetlb.h |   30 +++++++++++++++++++++++++++
> >  include/asm-sparc64/page.h    |    2 -
> >  include/asm-x86/hugetlb.h     |   28 +++++++++++++++++++++++++
> >  include/linux/hugetlb.h       |   46 ------------------------------------------
> 
> The way I read this, you took some arch-independent bits, like
> prepare_hugepage_range(), and copied them to several architectures.  How
> is this a cleanup?  Can they really not share common code? 

This question has been raised before. See: http://lkml.org/lkml/2008/3/28/267 .
