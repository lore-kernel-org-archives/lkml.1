Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179Ab0AHIE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab0AHIE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 03:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041Ab0AHIE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 03:04:28 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:62462 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab0AHIE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 03:04:27 -0500
Message-ID: <4B46E70A.7090205@dcl.info.waseda.ac.jp>
Date: Fri, 08 Jan 2010 17:04:26 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf lock: Implement basic sorting function of perf lock
References: <1261277805-27023-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1261997898.7135.72.camel@laptop>
In-Reply-To: <1261997898.7135.72.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009年12月28日 19:58, Peter Zijlstra wrote:
> On Sun, 2009-12-20 at 11:56 +0900, Hitoshi Mitake wrote:
>> +#define SINGLE_KEY(member)                                     \
>> +       static int lock_stat_key_ ## member(struct lock_stat *one,      \
>> +                                        struct lock_stat *two)         \
>> +       {                                                               \
>> +       if (one->member>  two->member)                                  \
>> +               return 1;                                               \
>> +       else                                                            \
>> +               return 0;                                               \
>> +       }
>
> Seems to me:
>
> 	return one->member>  two->member;
>
> Should suffice, no?
>
> [ I usually call the arguments to a comparator (l)eft/(r)ight or a/b,
>    but I guess one/two works too :-) ]
>
>

Yeah, your way is far smarter than mine :)
Body of this function can be in single line, I'll fix.

