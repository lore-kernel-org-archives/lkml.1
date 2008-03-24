Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYCXHDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYCXHDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 03:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbYCXHDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 03:03:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53103 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbYCXHDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 03:03:04 -0400
Message-ID: <47E751B2.1090002@cn.fujitsu.com>
Date: Mon, 24 Mar 2008 15:01:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: vladislav.yasevich@hp.com, sri@us.ibm.com,
       lksctp-developers@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SCTP: fix compile warning building without CONFIG_IPV6
References: <47E74608.7080007@cn.fujitsu.com> <20080323.235110.197600762.davem@davemloft.net>
In-Reply-To: <20080323.235110.197600762.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Li Zefan <lizf@cn.fujitsu.com>
> Date: Mon, 24 Mar 2008 14:11:20 +0800
> 
>> include/net/sctp/sctp.h: In function ‘sctp_v6_pf_init’:
>> include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
>>
>> This warning repeats several times.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Fixed in net-2.6 for several days already.

I looked into the git-log of net-2.6-26 and didn't find the fix.
So I posted this patch..
