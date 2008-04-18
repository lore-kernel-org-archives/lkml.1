Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYDRKU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYDRKU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 06:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbYDRKUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 06:20:51 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:36201 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYDRKUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 06:20:50 -0400
Message-Id: <4808753F.4010302@mxs.nes.nec.co.jp>
Date: Fri, 18 Apr 2008 19:17:35 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Chris Wright <chrisw@sous-sol.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: vmcoreinfo: add the symbol "phys_base"
References: <20080417010122.148289106@sous-sol.org> <20080417010334.951283202@sous-sol.org> <m17iewvnot.fsf@frodo.ebiederm.org> <20080417171616.GE17220@sequoia.sous-sol.org> <20080417172935.GA3708@redhat.com>
In-Reply-To: <20080417172935.GA3708@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Vivek Goyal wrote:
> On Thu, Apr 17, 2008 at 10:16:16AM -0700, Chris Wright wrote:
>> * Eric W. Biederman (ebiederm@xmission.com) wrote:
>>> Chris Wright <chrisw@sous-sol.org> writes:
>>>
>>>> -stable review patch.  If anyone has any objections, please let us know.
>>>> ---------------------
>>> This patch seems quite reasonable.  However as I read it, it is
>>> a feature enhancement, that allows a user space tool to function
>>> better.  Do we backport trivial features into stable now?
>> Function better, meaning work reliably?  Sounds like a fix not a
>> feature.
>>
> 
> I think in theory, makedumpfile should be able to guess phys_base by
> looking at the vmcore ELF headers (Look for program headers which are
> mapping kernel text and data and look at respective virtual address and
> physical addresses.).
> 
> I think this patch just makes it explicit instead putting extra logic
> for guessing the things.
> 
> To make sure makedumpfile is not broken with older kernels (in specific
> configurations where phys_base is not zero), I think one can also modify
> makedumpfile but I don't see any harm in putting this small change
> in stable kernel.
> 
> Keni'chi, can you please throw some light here if makedumpfile is broken with
> stable kernel or not (with phys_base not being zero).

I'm glad if this patch is merged into stable kernel, because this
patch solves the problem of a current makedumpfile. This patch is
very simple, and it doesn't have any bad influence for the kernel
building, the kernel operating or the other.

I will release the next makedumpfile which can run on also linux
without this patch. If both linux and makedumpfile have been fixed,
the condition that the problem occurs can be decreased.


Thanks
Ken'ichi Ohmichi

