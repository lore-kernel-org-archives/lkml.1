Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935027Ab0BZCXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 21:23:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934998Ab0BZCXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 21:23:33 -0500
Message-ID: <4B873173.80400@redhat.com>
Date: Fri, 26 Feb 2010 10:26:59 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: opurdila@ixiacom.com
CC: David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [net-next PATCH v5 2/3] sysctl: add proc_do_large_bitmap
References: <1267095756.12391.6.camel@Nokia-N900-42-11>
In-Reply-To: <1267095756.12391.6.camel@Nokia-N900-42-11>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Octavian Purdila wrote:
>> I think one of them is enough, since we already chose commas, why
>> do we need to add spaces? If you have some strong reason to add it,
>> I have no objections.
>>
> 
> It is just for simpler implementation. It is actually harder to restrict the separator to only commas insted of allowing both spaces and commas, because I rely on functions used for the integer vector handling. 
> 
> Maybe I should change those functions to be more generic and thus to allow more stricter input, but I am not sure if its worth it. Isn't a more permissive input format desirable?

I think you should ask Eric, since he proposed using commas. :)
I am fine with either of them.

Thanks.
