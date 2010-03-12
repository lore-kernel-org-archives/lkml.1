Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab0CLN1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 08:27:33 -0500
Received: from mail-qy0-f172.google.com ([209.85.221.172]:65133 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab0CLN1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 08:27:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hddN5V1Z4bm7hQ6V4DtulX7Sj1ySTsw18bybWM0bV7ywptVWvXygHGTZbETSkU+uqs
         duWPZGeUmVFuvWe/GtHszDcaJF2pRtS/S6MMTWyLPqBdnC6Iv7WanKRzvMWZbiXaJOPG
         36K6uo0unPXOdT8a+vmbJawcs7KGaNscMVWmg=
Message-ID: <4B9A413E.1030101@gmail.com>
Date: Fri, 12 Mar 2010 08:27:26 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       =?UTF-8?B?UGVudHRpbMOkIE1pa2E=?= <mika.penttila@ixonos.com>
Subject: Re: [PATCH 0/7] tcp: bugs and cleanup for 2.6.34-rc1
References: <4B98D592.6040301@gmail.com>	 <1268319664.2986.535.camel@edumazet-laptop>  <4B992A89.6040700@gmail.com> <1268331251.17462.51.camel@Joe-Laptop.home>
In-Reply-To: <1268331251.17462.51.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/10 1:14 PM, Joe Perches wrote:
> On Thu, 2010-03-11 at 12:38 -0500, William Allen Simpson wrote:
>>> http://git2.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commit;h=28b2774a0d5852236dab77a4147b8b88548110f1
>
> In that patch, it might be  better to use
> 	u16 s_data_desired = 0;
> not
> 	int s_data_desired = 0;
>
Actually, Eric wrote that part of the message, and that patch.  I expect
that ship has sailed, but you could submit a patch....
