Return-Path: <linux-kernel-owner+w=401wt.eu-S1751469AbZKGKTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbZKGKTI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 05:19:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbZKGKTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 05:19:06 -0500
Received: from mga05.intel.com ([192.55.52.89]:20307 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751381AbZKGKTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 05:19:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,699,1249282800"; 
   d="scan'208";a="511592127"
Date: Sat, 7 Nov 2009 17:52:30 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, therm: Only read the initial value of thermal LVT
	entry on BSP
Message-ID: <20091107095230.GA31533@ywang-moblin2.bj.intel.com>
References: <20091107001736.GA30790@ywang-moblin2.bj.intel.com> <1257562565.4083.485.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257562565.4083.485.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 06, 2009 at 06:56:05PM -0800, Suresh Siddha wrote:
> On Fri, 2009-11-06 at 16:17 -0800, Yong Wang wrote:
> > Only read the initial value of thermal LVT entry on BSP. The initial
> > value of thermal LVT entries on all APs always reads 0x10000 because
> > APs are woken up by BSP issuing INIT-SIPI-SIPI sequence to them and
> > LVT registers are reset to 0s except for mask bits which are set to
> > 1s when APs receive INIT IPI.
> > 
> > Also restore the value that BIOS has programmed on AP based on BSP's
> > info we saved since BIOS is always setting the same value for all
> > threads/cores.
> 
> Yong, I have appended a new patch with an enhanced change log and
> subject. In future, when you modify and post another version of the
> patch, can you please update the patch version and elaborate what has
> changed, why etc, so that it will be easier for the reviewers.
> 

Thanks a lot for your review and comments. Will follow the conventions
going forward.

