Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbZFZLyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbZFZLyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 07:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbZFZLxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 07:53:53 -0400
Received: from twosheds.infradead.org ([90.155.92.209]:44773 "EHLO
	twosheds.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZFZLxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 07:53:52 -0400
X-Greylist: delayed 2292 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jun 2009 07:53:52 EDT
Date: Fri, 26 Jun 2009 12:15:07 +0100 (BST)
From: David Woodhouse <dwmw2@infradead.org>
To: Chris Wright <chrisw@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, fenghua.yu@intel.com,
       akpm@linux-foundation.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH v2] IA64 Compilation Error Fix for Intel IOMMU Identity
 Mapping Support
In-Reply-To: <20090626020854.GG28176@x200.localdomain>
Message-ID: <alpine.LFD.2.00.0906261213400.6967@twosheds.infradead.org>
References: <20090625003841.GA12226@linux-os.sc.intel.com> <20090625095643F.fujita.tomonori@lab.ntt.co.jp> <20090625041605.GA9330@linux-os.sc.intel.com> <20090625134827W.fujita.tomonori@lab.ntt.co.jp> <1245913886.17089.91.camel@macbook.infradead.org>
 <1245966743.30355.42.camel@macbook.infradead.org> <20090625234342.GD28176@x200.localdomain> <alpine.LFD.2.01.0906251835060.3605@localhost.localdomain> <20090626015205.GE28176@x200.localdomain> <alpine.LFD.2.01.0906251858540.3605@localhost.localdomain>
 <20090626020854.GG28176@x200.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by twosheds.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009, Chris Wright wrote:

> * Linus Torvalds (torvalds@linux-foundation.org) wrote:
>> Ok. Sounds like what I want is to get this patch through the ia64 people,
>> after it has gotten some testing there. Since ia64 is where the current
>> kernel fails anyway, that sounds like the motivation will be there too.
>
> Yup, I agree.

Tony, please could you test what's in git://git.infradead.org/iommu-2.6.git

It builds, but we'd like to check that it works correctly with iommu=pt on 
IA64.

(I'm leaving Fenghua's performance improvement for later.)

-- 
dwmw2
