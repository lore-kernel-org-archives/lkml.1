Return-Path: <linux-kernel-owner+w=401wt.eu-S1763888AbZEAS3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763888AbZEAS3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 14:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755854AbZEAS31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 14:29:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:24686 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbZEAS30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 14:29:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,280,1239001200"; 
   d="scan'208";a="511745679"
From: "Luck, Tony" <tony.luck@intel.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 1 May 2009 11:29:25 -0700
Subject: RE: [RFC][PATCH 33/35] asm-generic/ptemap.h for HIGHPTE users
Thread-Topic: [RFC][PATCH 33/35] asm-generic/ptemap.h for HIGHPTE users
Thread-Index: AcnKiC49hMoKarJ/TmeaWEYX9YLi7AAAgVIw
Message-ID: <57C9024A16AD2D4C97DC78E552063EA39EF4688A@orsmsx505.amr.corp.intel.com>
References: <20090501144201.D31EF417@kernel>
	 <20090501144252.A2BDDE6B@kernel>
	 <57C9024A16AD2D4C97DC78E552063EA39EF467E5@orsmsx505.amr.corp.intel.com>
 <1241201452.29485.206.camel@nimitz>
In-Reply-To: <1241201452.29485.206.camel@nimitz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> You need to add a closing #endif here.
>
> Fixed, thanks.

ia64 build fails with:

arch/ia64/mm/init.c: In function 'put_kernel_page':
arch/ia64/mm/init.c:248: error: implicit declaration of function 'pte_alloc_kernel'
arch/ia64/mm/init.c:248: warning: assignment makes pointer from integer without a cast
make[1]: *** [arch/ia64/mm/init.o] Error 1


Which I fixed by adding a #include <linux/ptemap.h> to init.c

-Tony
