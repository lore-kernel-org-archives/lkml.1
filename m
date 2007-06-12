Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbXFLWtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbXFLWtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 18:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbXFLWtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 18:49:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbXFLWtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 18:49:24 -0400
Date: Tue, 12 Jun 2007 18:48:02 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, avi@qumranet.com,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: 2.6.22-rc4-mm2: kvm compile breakage with X86_CMPXCHG64=n
Message-ID: <20070612224801.GA20229@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Adrian Bunk <bunk@stusta.de>, avi@qumranet.com,
	linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070612000718.GS3588@stusta.de> <20070612032224.GA19293@redhat.com> <20070612150357.1685c622.akpm@linux-foundation.org> <20070612221629.GA24252@redhat.com> <20070612154345.84b954d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612154345.84b954d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 03:43:45PM -0700, Andrew Morton wrote:
 > On Tue, 12 Jun 2007 18:16:29 -0400
 > Dave Jones <davej@redhat.com> wrote:
 > 
 > >  > >  # Read KERNELRELEASE from include/config/kernel.release (if it exists)
 > >  > 
 > >  > This causes the i386 allmodconfig build to fail:
 > > 
 > > Seems to be doing its job rather effectively.
 > 
 > err, hang on.  I had a different patch in there which hilariously broke
 > the build all over the place, and dropping that has made your patch
 > come good.  I'll put it back.

This was all just a cunning trick to make me download and build an -mm
kernel wasn't it ? :-)

	Dave

-- 
http://www.codemonkey.org.uk
