Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbXHVHfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbXHVHfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 03:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbXHVHfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 03:35:21 -0400
Received: from mx12.go2.pl ([193.17.41.142]:42517 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750888AbXHVHfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 03:35:20 -0400
X-Greylist: delayed 5349 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2007 03:35:19 EDT
Date: Wed, 22 Aug 2007 09:36:22 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Andi Kleen <ak@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: RFC: drop support for gcc < 4.0
Message-ID: <20070822073622.GB1684@ff.dom.local>
References: <20070821132038.GA22254@ff.dom.local> <20070821093103.3c097d4a.randy.dunlap@oracle.com> <20070821173550.GC30705@stusta.de> <20070821191959.GC2642@bingen.suse.de> <20070821195433.GE30705@stusta.de> <alpine.LFD.0.999.0708211306560.30176@woody.linux-foundation.org> <20070821202113.GF30705@stusta.de> <alpine.LFD.0.999.0708211332330.30176@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708211332330.30176@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 01:32:50PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 21 Aug 2007, Adrian Bunk wrote:
> > 
> > How many people e.g. test -rc kernels compiled with gcc 3.2?
> 
> How could anybody know?

It shouldn't be so hard:

a) statistically: by doing some random math with:

int number_of_seemingly_gcc3.2_reports_eg_per_rc;
int number_of_all_such_reports_eg_per_rc;
int estimated_number_of_all_users_or_developers;
(or maybe some more...)

b) precisely (or even more): by adding proper and often updated
announcements, e.g:

"drivers/usb/host/ohci-pci.c:202: warning: unused variable `pdev'
(BTW, Angelina and Brad will be very suprised this warning is
yet possible!!!)"

Regards,
Jarek P.
