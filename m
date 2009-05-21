Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZEUBsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZEUBsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 21:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbZEUBsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 21:48:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbZEUBsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 21:48:11 -0400
Message-ID: <4A14B2D2.1090008@novell.com>
Date: Thu, 21 May 2009 10:48:02 +0900
From: Tejun Heo <teheo@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: suresh.b.siddha@intel.com
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "JBeulich@novell.com" <JBeulich@novell.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel-owner@vger.kernel.org" 
	<linux-kernel-owner@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap allocator
References: <1242305390-21958-1-git-send-email-tj@kernel.org>	 <1242436626.27006.8623.camel@localhost.localdomain>	 <4A0ED8D8.2010303@kernel.org>	 <1242500964.27006.8636.camel@localhost.localdomain>	 <4A0F672A.3000309@kernel.org>	 <1242674444.27006.8691.camel@localhost.localdomain>	 <4A11B9E7.8010707@zytor.com>	 <1242680835.27006.8734.camel@localhost.localdomain>	 <4A120B47.8060200@kernel.org>	 <1242860470.27006.10106.camel@localhost.localdomain>	 <4A149B89.3010104@kernel.org> <1242866163.27006.10125.camel@localhost.localdomain> <4A14B271.5010202@kernel.org>
In-Reply-To: <4A14B271.5010202@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> On NUMA, both remap and 4k add some level of TLB pressure.  remap will
> waste one more PMD TLB entry (dup) while 4k adds a bunch of 4k ones
> (non-dup but what used to be accessed by PMD TLB is now accessed with
> PTE TLB).

Correction: 4k TLBs are dups too.

Thanks.

-- 
tejun
