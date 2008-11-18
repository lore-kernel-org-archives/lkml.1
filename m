Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbYKRAJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbYKRAJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 19:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYKRAJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 19:09:35 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:59424 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbYKRAJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 19:09:34 -0500
Message-ID: <492207BD.8030807@ct.jp.nec.com>
Date: Mon, 17 Nov 2008 16:09:33 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com
Subject: Re: [PATCH v2 2/5] x86: ia32_signal: introduce COPY_SEG_STRICT
References: <491E4101.7010405@ct.jp.nec.com> <492201F2.1060804@ct.jp.nec.com> <4922027A.4060805@ct.jp.nec.com> <492203AE.7020206@zytor.com>
In-Reply-To: <492203AE.7020206@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Hiroshi Shimamoto wrote:
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> Impact: cleanup
>>
>> Introduce COPY_SEG_STRICT for ia32_restore_sigcontext().
>>
> 
> I don't like the name _STRICT() for this; if anything it seems to have 
> quite the opposite meaning.  I would suggest COPY_SEG_USER() or even 
> COPY_SEG_CPL3().

Sounds nice.
I haven't thought about the name. I could not catch wrong meaning from
_STRICT. My English skill isn't good.

thanks,
Hiroshi Shimamoto

