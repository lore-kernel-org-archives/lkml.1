Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbXFWTGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbXFWTGe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 15:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbXFWTGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 15:06:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbXFWTGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 15:06:17 -0400
Date: Sat, 23 Jun 2007 15:06:07 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wang Zhenyu <zhenyu.z.wang@intel.com>, carlo@alinoe.com,
       linux-kernel@vger.kernel.org, eric@anholt.net
Subject: Re: [PATCH][AGPGART] intel_agp: don't load if no IGD and AGP port
Message-ID: <20070623190607.GA29401@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Wang Zhenyu <zhenyu.z.wang@intel.com>, carlo@alinoe.com,
	linux-kernel@vger.kernel.org, eric@anholt.net
References: <alpine.LFD.0.98.0706181553450.3593@woody.linux-foundation.org> <20070619233716.GA5779@alinoe.com> <20070620011521.GB2856@zhen-devel.sh.intel.com> <20070620014227.GA4090@zhen-devel.sh.intel.com> <20070620140237.GB5524@alinoe.com> <20070620154610.GA2802@localhost.localdomain> <20070621054318.GA31381@zhen-devel.sh.intel.com> <20070623095203.66bb8572.akpm@linux-foundation.org> <20070623184221.GB18605@redhat.com> <20070623115049.248ff86e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070623115049.248ff86e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 11:50:49AM -0700, Andrew Morton wrote:
 > On Sat, 23 Jun 2007 14:42:21 -0400 Dave Jones <davej@redhat.com> wrote:
 > 
 > >  > I probably _could_ work this out, and kinda did with a bit of list-trolling
 > >  > (verdict: needed in 2.6.22) but please, take care to describe the
 > >  > importance of a patch in the changelog?
 > > 
 > > This got merged a day or two ago.
 > 
 > OK.  -stable didn't appear to get a copy though?

Correct. It'll need a slightly different fix due to the cleanups done in .22rc
I also wanted it to sit for a few days to make sure there aren't any
other nasties lurking that this churn has unearthed.

	Dave

-- 
http://www.codemonkey.org.uk
