Return-Path: <linux-kernel-owner+w=401wt.eu-S932873AbZJMGUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873AbZJMGUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 02:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758893AbZJMGUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 02:20:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:40837 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758832AbZJMGUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 02:20:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,550,1249282800"; 
   d="scan'208";a="735759185"
Subject: Re: [PATCH 6/6] mce-inject: use injected mce only during faked
 handler call
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4AD41793.9020400@jp.fujitsu.com>
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>
	 <4AC95F5A.4000708@jp.fujitsu.com>  <4AC96391.1060001@jp.fujitsu.com>
	 <1255072482.5228.157.camel@yhuang-dev.sh.intel.com>
	 <4ACEE5E0.3050701@jp.fujitsu.com>
	 <1255074286.5228.163.camel@yhuang-dev.sh.intel.com>
	 <4ACEF4D9.9090600@jp.fujitsu.com>
	 <1255079484.5228.201.camel@yhuang-dev.sh.intel.com>
	 <4AD3E731.7080900@jp.fujitsu.com>
	 <1255404495.6047.298.camel@yhuang-dev.sh.intel.com>
	 <4AD41793.9020400@jp.fujitsu.com>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 14:19:30 +0800
Message-Id: <1255414771.6047.405.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 14:00 +0800, Hidetoshi Seto wrote: 
> Huang Ying wrote:
> > On Tue, 2009-10-13 at 10:34 +0800, Hidetoshi Seto wrote: 
> >> How long do I have to wait your next post, which will fix my urgent issue on
> >> Nehalem?
> > 
> > I think my patch with title:
> > 
> > [BUGFIX -v2] x86, mce, inject: Make injected mce valid only during faked handler call
> > 
> > fixes this issue correctly.
> 
> I should note that there are 2 pending patches from you:
> 
> [BUGFIX -v2] x86, mce, inject: Make injected mce valid only during faked handler call
>   for issue A) injected mce could be consumed by real poll handler  
> 
> [BUGFIX -v7] x86, MCE: Fix bugs and issues of MCE log ring buffer
>   for issue B) log buffer is too small
>   and for issue C) log buffer is not ring buffer
>   (I'm not sure but there might be other targeting issues D), E) and so on.)
> 
> And the only one what I believe it is urgent is issue B).

I have talked with Ingo about this patch. But he has different idea
about MCE log ring buffer and he didn't want to merge the patch even as
an urgent bug fixes. It seems that another re-post can not convince him.

Best Regards,
Huang Ying


