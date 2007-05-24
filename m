Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbXEXXEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbXEXXEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbXEXXD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:03:59 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34458 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbXEXXD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:03:59 -0400
Message-ID: <465619CE.9000406@zytor.com>
Date: Thu, 24 May 2007 16:03:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
CC: Andi Kleen <ak@suse.de>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
References: <20070523224637.GB15887@linux-os.sc.intel.com> <200705242308.38360.ak@suse.de> <20070524211337.GB3692@linux-os.sc.intel.com> <200705242325.28011.ak@suse.de> <20070524212806.GA5249@linux-os.sc.intel.com>
In-Reply-To: <20070524212806.GA5249@linux-os.sc.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi wrote:
> 
> I can do it in intel setup function. But, the feature may not be activated
> unless the driver is loaded. Going by the hardware capability point
> of view, we can do it in setup function.
> 
> The feature appears in CPUID 6 (called Power Management Leaf) instead of
> regular CPUID 1 features.
> 

This sounds like it should be a new CPUID word?

	-hpa
