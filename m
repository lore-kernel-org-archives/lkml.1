Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbYAQWPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbYAQWPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756684AbYAQWPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:15:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33158 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595AbYAQWPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:15:18 -0500
Message-ID: <478FD12F.6020706@zytor.com>
Date: Thu, 17 Jan 2008 17:05:35 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andreas Herrmann3 <andreas.herrmann3@AMD.COM>
CC: Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug fixes
References: <20080116023955.597433000@intel.com> <20080116185748.GA11244@alberich.amd.com> <20080116203328.GA17869@linux-os.sc.intel.com> <20080117191211.GA12631@alberich.amd.com> <20080117203600.GB27778@elte.hu> <20080117210301.GC12631@alberich.amd.com> <20080117211308.GA7858@elte.hu> <20080117213131.GA25389@linux-os.sc.intel.com> <20080117214209.GA12811@elte.hu> <20080117220650.GE12631@alberich.amd.com>
In-Reply-To: <20080117220650.GE12631@alberich.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann3 wrote:
> 
> Yes, we must fix all aliases or reject the conflicting mapping.
> But fixing all aliases might not be that easy.
> (I've just seen a panic when using your patch ;-(
> 

Avoiding inconsistent aliases is definitely fundamental to supporting PAT.

	-hpa

