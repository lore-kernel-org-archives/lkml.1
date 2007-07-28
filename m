Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbXG1RLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbXG1RLj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 13:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbXG1RLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 13:11:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:54267 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbXG1RL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 13:11:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=PeF5Hf0frR4ZC/Xs5398P0/UkFHrf1amxrR69iFOxHuAY6YrnX44DvlBygBmtuYzvWsYfggmCLYAGMHvYZ/bO3D1HRBQYMY2ZxMUw8tj/o6VsWZJTGXD8VLA4E9IZVI+QvOZ2pD3wFLyH0aCvJNqJaiK1klij0QXGrOp3VVSTBk=
Message-ID: <46AB77CA.1060705@googlemail.com>
Date: Sat, 28 Jul 2007 19:07:22 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Bob Picco <bob.picco@hp.com>, Andy Whitcroft <apw@shadowen.org>,
       William Irwin <bill.irwin@oracle.com>, Tony Luck <tony.luck@intel.com>
Subject: mm/sparse.c compile error ( Re: 2.6.23-rc1-mm1 )
References: <20070725040304.111550f4.akpm@linux-foundation.org>
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

next randconfig error ( http://194.231.229.228/MM/randconfig-auto-87.mm_sparse.error )


...

mm/sparse.c: In function 'sparse_init':
mm/sparse.c:482: error: implicit declaration of function 'sparse_early_usemap_alloc'
mm/sparse.c:482: warning: assignment makes pointer from integer without a cast
make[1]: *** [mm/sparse.o] Error 1
make: *** [mm] Error 2
make: *** Waiting for unfinished jobs....

...


guessing while this patch , but I am not really sure :

fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch


Regards,

Gabriel C
