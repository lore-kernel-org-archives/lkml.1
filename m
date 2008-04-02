Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbYDBRnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbYDBRnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbYDBRnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:43:06 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41100 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301AbYDBRnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:43:03 -0400
Subject: Re: [PATCH 1/3] hugetlbfs: architecture header cleanup
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, schwidefsky@de.ibm.com,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       Tony Luck <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <1207146415.4980.11.camel@localhost.localdomain>
References: <1207145843.4980.7.camel@localhost.localdomain>
	 <1207146415.4980.11.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 10:42:56 -0700
Message-Id: <1207158176.23710.7.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-02 at 16:26 +0200, Gerald Schaefer wrote:
> 
>  include/asm-ia64/hugetlb.h    |   21 +++++++++++++++++++
>  include/asm-ia64/page.h       |    6 -----
>  include/asm-powerpc/hugetlb.h |   35 +++++++++++++++++++++++++++++++
>  include/asm-powerpc/page_64.h |    7 ------
>  include/asm-sh/hugetlb.h      |   28 +++++++++++++++++++++++++
>  include/asm-sparc64/hugetlb.h |   30 +++++++++++++++++++++++++++
>  include/asm-sparc64/page.h    |    2 -
>  include/asm-x86/hugetlb.h     |   28 +++++++++++++++++++++++++
>  include/linux/hugetlb.h       |   46 ------------------------------------------

The way I read this, you took some arch-independent bits, like
prepare_hugepage_range(), and copied them to several architectures.  How
is this a cleanup?  Can they really not share common code? 

-- Dave

