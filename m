Return-Path: <linux-kernel-owner+w=401wt.eu-S1759030AbZFQSbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030AbZFQSbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZFQSbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:31:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58663 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZFQSbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:31:44 -0400
Message-ID: <4A393651.2090400@zytor.com>
Date: Wed, 17 Jun 2009 11:30:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: Huang Ying <ying.huang@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "yinghai@kernel.org" <yinghai@kernel.org>
Subject: Re: [PATCH] x86: efi/e820 table merge fix
References: <E1MGgRQ-0002pu-6Z@eag09.americas.sgi.com> <1245201005.11965.4.camel@yhuang-dev.sh.intel.com> <4A384914.1090900@zytor.com> <1245203099.11965.7.camel@yhuang-dev.sh.intel.com> <4A386B14.8030702@zytor.com> <1245215302.11965.19.camel@yhuang-dev.sh.intel.com> <20090617145831.GA725@sgi.com>
In-Reply-To: <20090617145831.GA725@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cliff Wickman wrote:
> 
> Paul Jackson retired from SGI a while back.  I haven't seen him
> participating in the LKML.  But he must have been trying to assure 
> that, as Peter says, memory that isn't WB doesn't get into the usable
> pool.
> 

Actually, it's not certain; he might just (incorrectly) have thought it
was easier than looking at the memory type.  Either way, though, keeping
the check in is the conservative thing to do.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

