Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab0BCRQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:16:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46913 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932562Ab0BCRQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:16:35 -0500
Message-ID: <4B69AE34.9070704@zytor.com>
Date: Wed, 03 Feb 2010 09:11:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for hweight_long(CONSTANT)
References: <20100130094515.475881280@intel.com>	 <20100130094957.692671259@intel.com>	 <20100201124825.cc024f2a.akpm@linux-foundation.org>	 <20100203133951.GA24357@localhost>	 <20100203070825.e36b3932.akpm@linux-foundation.org>	 <1265210157.24455.646.camel@laptop>	 <20100203074251.e2caa3f3.akpm@linux-foundation.org> <1265212054.24455.680.camel@laptop>
In-Reply-To: <1265212054.24455.680.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2010 07:47 AM, Peter Zijlstra wrote:
> 
> From what I know the popcnt ins on x86 is relatively new, hpa was going
> to look at supporting it using alternatives.
> 

And kernel-specific stuff like alternatives is pretty much the one thing
that gcc *can't* do for us.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

