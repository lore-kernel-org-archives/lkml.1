Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbYJVIPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbYJVIPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 04:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbYJVIOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 04:14:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:57390 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbYJVIOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 04:14:49 -0400
Message-ID: <48FEE065.20406@windriver.com>
Date: Wed, 22 Oct 2008 16:12:21 +0800
From: Chen Zumeng <zumeng.chen@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Ryo Tsuruta <ryov@valinux.co.jp>, haotian.zhang@windriver.com
CC: bruce.ashfield@windriver.com, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.8.0: Introduction
References: <20081017.160950.71109894.ryov@valinux.co.jp>	<48FDB8AC.9020707@windriver.com>	<48FEDC63.308@windriver.com> <20081022.170536.193712541.ryov@valinux.co.jp>
In-Reply-To: <20081022.170536.193712541.ryov@valinux.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Oct 2008 08:13:50.0633 (UTC) FILETIME=[1D8EC990:01C9341E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryo Tsuruta wrote:
> Hi Chen,
> 
>> Chen Zumeng wrote:
>>> Hi, Ryo Tsuruta
>>> And our test team want to test bio_tracking as your benchmark reports,
>>> so would you please send me your test codes? Thanks in advance.
>> Hi Ryo Tsuruta,
>>
>> I wonder if you received last email, so I reply this email to ask
>> for your bio_tracking test codes to generate your benchmark reports
>> as shown in your website. Thanks in advance :)
Thanks for you quick reply :)

Regards,
Zumeng
> 
> I've uploaded two scripts here:
> http://people.valinux.co.jp/~ryov/dm-ioband/scripts/xdd-count.sh
> http://people.valinux.co.jp/~ryov/dm-ioband/scripts/xdd-size.sh
> 
> xdd-count.sh controls bandwidth based on the number of I/O requests,
> and xdd-size.sh controls bandwidth based onthe number of I/O sectors.
> Theses scritpts require xdd disk I/O testing tool which can be
> downloaded from here:
> http://www.ioperformance.com/products.htm
> 
> Please feel free to ask me questions if you have any questions.
OK thanks.
> 
>>> P.S. The following are my changes to avoid schedule_timeout:
> 
> Thanks, but your patch seems to cause a problem when ioband devices
> which have the same name are created at the same time. I will fix the
> issue in the next release.
Maybe, hoping your next release :)

Zumeng
> 
> Thanks,
> Ryo Tsuruta
> 

