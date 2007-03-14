Return-Path: <linux-kernel-owner+w=401wt.eu-S964825AbXCNXdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825AbXCNXdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 19:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964826AbXCNXdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 19:33:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:25082 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964825AbXCNXdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 19:33:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,285,1170662400"; 
   d="scan'208"; a="58657650:sNHT23361336"
Date: Wed, 14 Mar 2007 16:33:01 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrea Arcangeli <andrea@suse.de>, Anton Blanchard <anton@samba.org>,
       Rik van Riel <riel@redhat.com>,
       Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
Message-ID: <20070314233301.GK30596@linux-os.sc.intel.com>
References: <20070312220042.GA807@kryten> <45F63266.1080509@yahoo.com.au> <20070313094559.GC8992@v2.random> <45F67796.4040508@yahoo.com.au> <20070313103134.GF8992@v2.random> <45F67F02.5020401@yahoo.com.au> <20070313105742.GG8992@v2.random> <45F68713.9040608@yahoo.com.au> <20070313114215.GI8992@v2.random> <45F6945B.2030309@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F6945B.2030309@yahoo.com.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 05:08:59AM -0700, Nick Piggin wrote:
> I would agree that it points to MySQL scalability issues, however the
> fact that such large gains come from tcmalloc is still interesting.

What glibc version are you, Anton and others are using?

Does that version has this fix included?

Dynamically size mmap treshold if the program frees mmaped blocks.

http://sources.redhat.com/cgi-bin/cvsweb.cgi/libc/malloc/malloc.c.diff?r1=1.158&r2=1.159&cvsroot=glibc

thanks,
suresh
