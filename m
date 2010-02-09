Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab0BIG5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 01:57:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58516 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753736Ab0BIG5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 01:57:43 -0500
Message-ID: <4B710776.9020800@cn.fujitsu.com>
Date: Tue, 09 Feb 2010 14:57:58 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
CC: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 11/13] net: irda: use seq_list_foo() helpers
References: <4B6B77FE.5000104@cn.fujitsu.com> <4B6B78AD.1030809@cn.fujitsu.com> <4B6C051F.3080702@gmail.com>
In-Reply-To: <4B6C051F.3080702@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paulius Zaleckas wrote:
> On 02/05/2010 03:47 AM, Li Zefan wrote:
> [...]
>>   /* Return entry after v, and increment pos */
>> @@ -1148,14 +1137,7 @@ static void *irlan_seq_next(struct seq_file
>> *seq, void *v, loff_t *pos)
>>   {
>>       struct list_head *nxt;
> 
> you should remove nxt declaration.
> 

Thanks! Will fix.

