Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbXFYBDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbXFYBDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 21:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbXFYBDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 21:03:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:34713 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbXFYBDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 21:03:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,457,1175497200"; 
   d="scan'208";a="260598050"
Date: Mon, 25 Jun 2007 09:01:41 +0800
From: Wang Zhenyu <zhenyu.z.wang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, carlo@alinoe.com,
       linux-kernel@vger.kernel.org, eric@anholt.net
Subject: Re: [PATCH][AGPGART] intel_agp: don't load if no IGD and AGP port
Message-ID: <20070625010141.GA31149@zhen-devel.sh.intel.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Dave Jones <davej@redhat.com>, carlo@alinoe.com,
	linux-kernel@vger.kernel.org, eric@anholt.net
References: <alpine.LFD.0.98.0706181553450.3593@woody.linux-foundation.org> <20070619233716.GA5779@alinoe.com> <20070620011521.GB2856@zhen-devel.sh.intel.com> <20070620014227.GA4090@zhen-devel.sh.intel.com> <20070620140237.GB5524@alinoe.com> <20070620154610.GA2802@localhost.localdomain> <20070621054318.GA31381@zhen-devel.sh.intel.com> <20070623095203.66bb8572.akpm@linux-foundation.org> <20070623184221.GB18605@redhat.com> <20070623115049.248ff86e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070623115049.248ff86e.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.15-1.2054_FC5smp i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.23 11:50:49 +0000, Andrew Morton wrote:
> On Sat, 23 Jun 2007 14:42:21 -0400 Dave Jones <davej@redhat.com> wrote:
> 
> >  > I probably _could_ work this out, and kinda did with a bit of list-trolling
> >  > (verdict: needed in 2.6.22) but please, take care to describe the
> >  > importance of a patch in the changelog?
> > 
> > This got merged a day or two ago.
> 
> OK.  -stable didn't appear to get a copy though?

The point is that as those host bridges only support PCIE with no AGP port, our
AGP driver shouldn't act. And by another side it can fix possible mystery problems
(like Carlo's P965) when our AGP driver does act then. 
