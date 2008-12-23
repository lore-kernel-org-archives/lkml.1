Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbYLWFs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbYLWFs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 00:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYLWFsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 00:48:17 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:33677 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYLWFsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 00:48:17 -0500
Message-ID: <49507B88.1030407@ct.jp.nec.com>
Date: Mon, 22 Dec 2008 21:47:52 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC -tip 2/4] x86: uaccess: introduce __{get|put}_user exception
 handling framework
References: <49507534.5080401@ct.jp.nec.com> <495075B0.9020104@ct.jp.nec.com> <73c1f2160812222138g3968afb5v20662338ea0cf5d5@mail.gmail.com>
In-Reply-To: <73c1f2160812222138g3968afb5v20662338ea0cf5d5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> On Tue, Dec 23, 2008 at 12:22 AM, Hiroshi Shimamoto
> <h-shimamoto@ct.jp.nec.com> wrote:
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> Impact: introduce new framework
>>
>> Introduce exception handling framework.
>> __{get|put}_user_ex_try() begins exception block and
>> __{get|put}_user_ex_catch() ends block and if an exception occurred in this
>> block using __{get|put}_user_ex, direct jump to __{get|put}_user_ex_catch()
>> and err is set to specified value.
> 
> You shouldn't do this.  According to the gcc manual[1], "Speaking of
> labels, jumps from one asm to another are not supported. The
> compiler's optimizers do not know about these jumps, and therefore
> they cannot take account of them when deciding how to optimize."
> 
> [1] http://gcc.gnu.org/onlinedocs/gcc-4.3.2/gcc/Extended-Asm.html
> 
thanks so much for this information!
I didn't know about this and it's what I want to know, thinking
about this series.

Thanks,
Hiroshi
