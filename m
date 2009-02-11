Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbZBKS6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbZBKS6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 13:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbZBKS6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 13:58:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:28097 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755955AbZBKS6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 13:58:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,193,1233561600"; 
   d="scan'208";a="430184192"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Dean Nelson <dcn@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Wed, 11 Feb 2009 10:58:19 -0800
Subject: RE: [PATCH] SGI IA64 UV: fix ia64 build error in the linux-next	tree
Thread-Topic: [PATCH] SGI IA64 UV: fix ia64 build error in the linux-next
	tree
Thread-Index: AcmMWj2Ha/2gb8L3QSS1BCj8zPINewAH0izQ
Message-ID: <57C9024A16AD2D4C97DC78E552063EA361689D7D@orsmsx505.amr.corp.intel.com>
References: <20090209162520.GA4882@sgi.com>
 <20090210132555.be1c1462.akpm@linux-foundation.org>
 <20090211150103.GA15814@sgi.com> <20090211150536.GE10525@elte.hu>
In-Reply-To: <20090211150536.GE10525@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What question was that? Folding back across that distance is not possible
> in a Git workflow. I do regular cross-builds - the build bug did not trigger
> with the ia64 defconfig.

I'm confused by this, as it definitely triggered for me.  Perhaps
my build scripts do things a bit differently.  Essentially I do:

        $ for c in `ls arch/ia64/configs`
        > do
        >       cp arch/ia64/configs/$i .config
        >       yes '' | make oldconfig
        >       make
        > done

Which takes the default answer for any new questions that crop
up.  This enabled the GRU driver in the case of the generic_defconfig,
and so the build failed because of the lack of asm/uv.h

-Tony
