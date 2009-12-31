Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbZLaDBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbZLaDBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 22:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZLaDBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 22:01:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54729 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbZLaDBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 22:01:54 -0500
Message-ID: <4B3C13B0.6080600@cn.fujitsu.com>
Date: Thu, 31 Dec 2009 11:00:00 +0800
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
References: <vxv6sfpjggfx6v68yv1eecrx.1262215615671@email.android.com> <1262216506.2749.254.camel@mulgrave.site> <4B3BE63B.70907@zytor.com> <20091231003046.GC2384@ghostprotocols.net>
In-Reply-To: <20091231003046.GC2384@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnaldo Carvalho de Melo wrote:

> 
> Conclusion: at 'perf record' time store the address of a well know
> symbol (_text) into the perf.data header. Later, at perf report time, if
> using a vmlinux file, calculate the relocation by subtracting the same
> well known symbol from the one stored in the header.
> 
> So no need for ioctl or boot stuff.
> 

I'm little confused, how to get the load symbol address?
It's not a good way, if you get it from '/proc/kallsyms', we can't assume kernel
has this file.

> I'll do that tomorrow, if Xiao doesn't beats me to it :-)
> 

Of course, please do if you have a better way :-)

Thanks,
Xiao
