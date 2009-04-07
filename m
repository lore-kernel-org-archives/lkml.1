Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbZDGH5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbZDGH5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbZDGH45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:56:57 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56001 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbZDGH45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:56:57 -0400
Date: Tue, 7 Apr 2009 08:56:40 +0100
From: Matthew Garrett <mjg@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Lutomirski <amluto@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kyle McMartin <kyle@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Mark Gross <mgross@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29: can't resume from suspend with DMAR (intel iommu) enabled
Message-ID: <20090407075640.GA16516@srcf.ucam.org>
References: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com> <20090324203259.GC26930@elte.hu> <1238003581.2085.53.camel@macbook.infradead.org> <20090325175908.GA25518@elte.hu> <1239051362.22733.87.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239051362.22733.87.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 01:56:01PM -0700, David Woodhouse wrote:

> Dirk reported the same panic, but we've just turned his iommu back on
> and completely failed to reproduce the problem -- so I'm kind of stuck.

I saw this on a T400, but only on the first boot after enabling DMAR - 
power cycling "fixed" it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
