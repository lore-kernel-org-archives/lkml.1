Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324AbZEVA5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbZEVA5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 20:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbZEVA5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 20:57:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:5524 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538AbZEVA5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 20:57:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,230,1241420400"; 
   d="scan'208";a="145667124"
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap
 allocator
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "JBeulich@novell.com" <JBeulich@novell.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel-owner@vger.kernel.org" 
	<linux-kernel-owner@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A15E130.1070808@kernel.org>
References: <1242305390-21958-1-git-send-email-tj@kernel.org>
	 <1242436626.27006.8623.camel@localhost.localdomain>
	 <4A0ED8D8.2010303@kernel.org>
	 <1242500964.27006.8636.camel@localhost.localdomain>
	 <4A0F672A.3000309@kernel.org>
	 <1242674444.27006.8691.camel@localhost.localdomain>
	 <4A11B9E7.8010707@zytor.com>
	 <1242680835.27006.8734.camel@localhost.localdomain>
	 <4A120B47.8060200@kernel.org>
	 <1242860470.27006.10106.camel@localhost.localdomain>
	 <4A149B89.3010104@kernel.org>
	 <1242866163.27006.10125.camel@localhost.localdomain>
	 <4A14B271.5010202@kernel.org>
	 <1242933008.27006.10150.camel@localhost.localdomain>
	 <4A15E130.1070808@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 21 May 2009 17:55:02 -0700
Message-Id: <1242953702.27006.10152.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-21 at 16:18 -0700, Tejun Heo wrote:
> No, I'll let the first chunk allocation happen the same way for cpus
> available on boot and then just do 4k allocations for whatever
> necessary afterward.  The needed code change in percpu proper isn't
> that big.

Ok. It will be more cleaner this way.

thanks,
suresh

