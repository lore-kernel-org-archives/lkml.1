Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbXHUUuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbXHUUuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbXHUUui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:50:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:38115 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbXHUUuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:50:37 -0400
In-Reply-To: <20070821202113.GF30705@stusta.de>
References: <20070821132038.GA22254@ff.dom.local> <20070821093103.3c097d4a.randy.dunlap@oracle.com> <20070821173550.GC30705@stusta.de> <20070821191959.GC2642@bingen.suse.de> <20070821195433.GE30705@stusta.de> <alpine.LFD.0.999.0708211306560.30176@woody.linux-foundation.org> <20070821202113.GF30705@stusta.de>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <27c412eea99f1f80a3002e9668bd31f8@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jarek Poplawski <jarkao2@o2.pl>, Andi Kleen <ak@suse.de>,
       linux-arch@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: RFC: drop support for gcc < 4.0
Date: Tue, 21 Aug 2007 22:49:49 +0200
To: Adrian Bunk <bunk@kernel.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> How many people e.g. test -rc kernels compiled with gcc 3.2?

Why would that matter?  It either works or not.  If it doesn't
work, it can either be fixed, or support for that old compiler
version can be removed.

The only other policy than "only remove support if things are
badly broken" would be "only support what the GCC team supports",
which would be >= 4.1 now; and there are very good arguments for
supporting more than that with the Linux kernel.


Segher

