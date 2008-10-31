Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbYJaBJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbYJaBJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 21:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYJaBIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 21:08:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51152 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbYJaBIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 21:08:50 -0400
Message-ID: <490A5A80.3070203@zytor.com>
Date: Thu, 30 Oct 2008 18:08:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: cpu2000(both float and int) 13% regression with 2.6.28-rc1
References: <1225175522.1685.57.camel@ymzhang> <20081028080327.GB15734@elte.hu> <20081028202649.GJ30573@linux-os.sc.intel.com> <7E82351C108FA840AB1866AC776AEC46401F518D@orsmsx505.amr.corp.intel.com>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC46401F518D@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:
> 
> We figured out that this is not related to signals. But to this mismerge here
> 
>>  +#define X86_FEATURE_AMDC1E  (3*32+21) /* AMD C1E detected */
>> + #define X86_FEATURE_XTOPOLOGY       (3*32+21) /* cpu topology enum extensions */
> 
> I had earler sent a patch to fix this.
> http://marc.info/?l=linux-kernel&m=122341178202930&w=2
> 
> But, somehow I don’t see this patch either in Linus's git or in tip.
> 
> ingo, hpa: Can you push that patch along.
> 

OK, thought it already had been.  I will investigate later tonight.

	-hpa

