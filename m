Return-Path: <linux-kernel-owner+w=401wt.eu-S1763445AbYCECKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763445AbYCECKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 21:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYCECKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 21:10:09 -0500
Received: from mga05.intel.com ([192.55.52.89]:41352 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752061AbYCECKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 21:10:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,444,1199692800"; 
   d="scan'208";a="528833188"
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080304112741.GA13428@linux.vnet.ibm.com>
References: <200803030316.07165.rjw@sisk.pl>
	 <20080304112741.GA13428@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 05 Mar 2008 10:06:22 +0800
Message-Id: <1204682782.3248.189.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-04 at 16:57 +0530, Dhaval Giani wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9978
> > Subject		: 2.6.25-rc1: volanoMark 45% regression
> > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > Date		: 2008-02-13 10:30
> > References	: http://lkml.org/lkml/2008/2/13/128
> > Handled-By	: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > 		  Balbir Singh <balbir@linux.vnet.ibm.com>
>  
> Peter's revert of the load balance patches should fix this one. Yanmin,
> could you please confirm if the patch at
> http://lkml.org/lkml/2008/2/25/202 helps?
I tested it against 2.6.25-rc3 on my 16-core tigerton machine. It really improves
volano result although it doesn't recover all the result.
Comparing with 2.6.24, without the patch, volanoMark has about 50% regression
with 2.6.25-rc3. With the patch, volanoMark has about 15% regression.

-yanmin


