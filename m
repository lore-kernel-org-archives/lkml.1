Return-Path: <linux-kernel-owner+w=401wt.eu-S965424AbXA3Hke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965424AbXA3Hke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 02:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965425AbXA3Hke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 02:40:34 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40212 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965424AbXA3Hkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 02:40:33 -0500
Message-ID: <45BEF669.1060600@hitachi.com>
Date: Tue, 30 Jan 2007 16:40:25 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@osdl.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 4/4] coredump: documentation for proc and sysctl]
References: <45BA0E41.2080204@hitachi.com> <20070126165847.GB1269@elf.ucw.cz>
In-Reply-To: <20070126165847.GB1269@elf.ucw.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel and Andrew,

Pavel Machek wrote:
>>This patch adds the documentation for the following parameters:
>>  /proc/<pid>/core_flags
>>  /proc/sys/kernel/core_flags_enable
> 
> Sysctl seems really strange to me. Either the feature is safe to use,
> or it is not. Users can already ulimit -c 0, and we do not have
> "/proc/sys/kernel/allow_users_to_disable_their_core_dumps".

Oh, I had forgotten that.  Thank you for pointing out.  The purpose of
this sysctl is to prevent a bad process from hiding its memory.
But as you say, this sysctl isn't enough for the purpose.

Andrew wrote:
> Does this feature have any security implications?  For example, there might
> be system administration programs which force a coredump on a "bad"
> process, and leave the core somewhere for the administrator to look at. 

I have never heard of the story that ulimit -c 0 bothered an
administrator who wanted to force a coredump.  So even without this
sysctl, the administrator wouldn't bother about security concerns.
I'll drop it from the next version.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Ltd., Systems Development Laboratory


