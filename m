Return-Path: <linux-kernel-owner+w=401wt.eu-S936255AbYBCHcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936255AbYBCHcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 02:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757693AbYBCHck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 02:32:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63686 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbYBCHcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 02:32:39 -0500
Message-ID: <47A56DDA.9000907@cn.fujitsu.com>
Date: Sun, 03 Feb 2008 15:31:38 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix compile waring building without CONFIG_SYSCTL
References: <47A55CA4.9090804@cn.fujitsu.com> <20080203071251.GB19020@elte.hu>
In-Reply-To: <20080203071251.GB19020@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> +#ifdef CONFIG_SYSCTL
>>  static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
>> +#endif
> 
> instead of adding another #ifdef, a much cleaner solution would be to 
> just reorder do_nmi_callback() with unknown_nmi_panic_callback(), and 
> eliminate the prototype altogether.
> 
> 	Ingo
> 

I was wondering if a smaller patch will be better. But no doult cleaner
code is better. :)
