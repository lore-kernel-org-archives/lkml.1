Return-Path: <linux-kernel-owner+w=401wt.eu-S1752437AbZLaKwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbZLaKwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 05:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZLaKwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 05:52:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57954 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbZLaKwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 05:52:24 -0500
Message-ID: <4B3C81F7.6050800@cn.fujitsu.com>
Date: Thu, 31 Dec 2009 18:50:31 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: record relocation offset
References: <vxv6sfpjggfx6v68yv1eecrx.1262215615671@email.android.com> <1262216506.2749.254.camel@mulgrave.site> <4B3BE63B.70907@zytor.com> <20091231003046.GC2384@ghostprotocols.net> <4B3C13B0.6080600@cn.fujitsu.com> <20091231103609.GE2384@ghostprotocols.net>
In-Reply-To: <20091231103609.GE2384@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnaldo Carvalho de Melo wrote:

> 
> Well, then its just a matter of exposing _text as
> /sys/kernel/sections/.text, as we already have for modules:
> 
> [acme@ana linux-2.6-tip]$ cat /sys/module/ipv6/sections/.text 
> 0xfa0c2000
> 
> Which matches
> 
> nf_conntrack_ipv6 17548 2 - Live 0xfa147000
> ipv6 239420 32 ip6t_REJECT,nf_conntrack_ipv6, Live 0xfa0c2000
> [acme@ana linux-2.6-tip]$
> 
> But even as a quick transational assist, we can look at kallsyms at
> 'perf record' time.
> 

Ah, i see, it's really a nice way.

>>> I'll do that tomorrow, if Xiao doesn't beats me to it :-)
> 
>> Of course, please do if you have a better way :-)
> 
> I meant, if you didn't write the patch first, while I was sleeping :-)
> 
> I'll work on it today after some coffee and errands.
> 

Please do :-)

Xiao
