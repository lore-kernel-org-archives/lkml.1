Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZDKGEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZDKGEt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 02:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZDKGEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 02:04:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58120 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZDKGEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 02:04:39 -0400
Subject: Re: 2.6.29: can't resume from suspend with DMAR (intel iommu)
 enabled
From: David Woodhouse <dwmw2@infradead.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Lutomirski <amluto@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kyle McMartin <kyle@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Mark Gross <mgross@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090407075640.GA16516@srcf.ucam.org>
References: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com>
	 <20090324203259.GC26930@elte.hu>
	 <1238003581.2085.53.camel@macbook.infradead.org>
	 <20090325175908.GA25518@elte.hu>
	 <1239051362.22733.87.camel@macbook.infradead.org>
	 <20090407075640.GA16516@srcf.ucam.org>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 23:04:12 -0700
Message-Id: <1239429852.712.1532.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 08:56 +0100, Matthew Garrett wrote:
> On Mon, Apr 06, 2009 at 01:56:01PM -0700, David Woodhouse wrote:
> 
> > Dirk reported the same panic, but we've just turned his iommu back on
> > and completely failed to reproduce the problem -- so I'm kind of stuck.
> 
> I saw this on a T400, but only on the first boot after enabling DMAR - 
> power cycling "fixed" it.

OK, that should be fixed (amongst other things) in
git.infradead.org/users/dwmw2/iommu-suspend-2.6.29.git and in the Fedora
2.6.29.1-68.fc11 kernel. Thanks.

http://www.kerneloops.org/raw.php?rawid=346794

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

