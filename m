Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbZLaDAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbZLaDAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 22:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZLaDAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 22:00:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58067 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbZLaDAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 22:00:38 -0500
Message-ID: <4B3C1363.7000009@cn.fujitsu.com>
Date: Thu, 31 Dec 2009 10:58:43 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: James Bottomley <James.Bottomley@suse.de>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: record relocation offset
References: <vxv6sfpjggfx6v68yv1eecrx.1262215615671@email.android.com> <1262216506.2749.254.camel@mulgrave.site> <4B3BE63B.70907@zytor.com>
In-Reply-To: <4B3BE63B.70907@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Thanks for you review and tell us the better way to get relocation offset.

H. Peter Anvin wrote:

> 
> The first I saw of this thread was a proposed patch that would give the
> relocation offset of the monolithic kernel, both on 32 and 64 bits,
> without any explanation of the usage model.  As such, from my point of
> view this has always been about the monolithic kernel, until your post
> mentioned modules (which the proposed patch would have done nothing about.)
> 

We no need care modules symbols since we get module load address from
'/proc/modules', no matter is relocated or not. And perf tools just use
this way. So, it done nothing about it in my patch, maybe i should mention
it in my patch's changlog

Thanks,
Xiao






