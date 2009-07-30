Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067AbZG3XTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbZG3XTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 19:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbZG3XTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 19:19:03 -0400
Received: from ozlabs.org ([203.10.76.45]:56741 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbZG3XTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 19:19:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [PATCH] next-20090730 lguest build breaks with pfn_pmd()
Date: Fri, 31 Jul 2009 08:49:00 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; i686; ; )
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       lguest@ozlabs.org, sfr@canb.auug.org.au
References: <20090729173611.b82478cd.sfr@canb.auug.org.au> <20090730120533.GB4955@linux.vnet.ibm.com>
In-Reply-To: <20090730120533.GB4955@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907310849.00939.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jul 2009 09:35:33 pm Kamalesh Babulal wrote:
> Hi Rusty,
> 
> 	next-20090729 allmodconfig build breaks at
> 
> drivers/lguest/page_tables.c: In function 'setup_pagetables':
> drivers/lguest/page_tables.c:987: error: incompatible type for argument 2 of 'pfn_pmd'
> drivers/lguest/page_tables.c:994: error: expected ';' before ')' token
> drivers/lguest/page_tables.c:994: error: expected statement before ')' token
> make[2]: *** [drivers/lguest/page_tables.o] Error 1
> 
> build failure is introduced by commit e07dd6220a4bf81a2549e7e37523a2557547d9d7
> I have tested the patch for the build failure only.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Thanks, applied!

Rusty.
