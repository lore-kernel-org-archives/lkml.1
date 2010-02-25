Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab0BYJuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 04:50:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab0BYJui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 04:50:38 -0500
Message-ID: <4B8648BF.5070606@redhat.com>
Date: Thu, 25 Feb 2010 17:54:07 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: opurdila@ixiacom.com
CC: David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [net-next PATCH v5 2/3] sysctl: add proc_do_large_bitmap
References: <1267091195.12391.2.camel@Nokia-N900-42-11>
In-Reply-To: <1267091195.12391.2.camel@Nokia-N900-42-11>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Octavian Purdila wrote:
>> Hi,
>>
>> Still a small problem, if I do write(fd, "50000,50100", 12) I will
>> get a return value of 11, which should mean 11 bytes are written,
>> however, actually only the first 6 bytes are accepted.
>>
>> The rest looks better now.
>>
>> Or am I missing something here? :)
>>
> 
> Will take a look at this a bit later today, thanks for testing.
> 
> In the meanwhile what are your thougths on the "1 2 3" issue, are you OK with accepting spaces as well as commas as separators?

I think one of them is enough, since we already chose commas, why
do we need to add spaces? If you have some strong reason to add it,
I have no objections.


Thanks.
