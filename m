Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbYKLSer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbYKLSer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbYKLSeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:34:37 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:14635 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbYKLSeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:34:36 -0500
Message-ID: <491B21BB.5080001@ct.jp.nec.com>
Date: Wed, 12 Nov 2008 10:34:35 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: ia32_signal: remove unnecessary padding
References: <491A48E9.8020909@ct.jp.nec.com> <491A496B.5010505@ct.jp.nec.com> <878wrpdrwq.fsf@basil.nowhere.org>
In-Reply-To: <878wrpdrwq.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> writes:
> 
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> Impact: cleanup
> 
> Actually it's not a cleanup.
> 
>> Remove unnecessary paddings, this saves 4 bytes.
> 
> This might actually break code. The code is not actually used,
> but only kept around because some old gdb versions used this
> code as a marker for detecting signals.

I think, this cleanup doesn't change the code copied to user stack.
It removes additional 2 bytes from each struct, and these had not
been copied to user stack, because the structures were 10 bytes and
frame->retcode is 8 bytes.

Thanks,
Hiroshi Shimamoto
