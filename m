Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928AbYKQXww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbYKQXww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 18:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYKQXwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 18:52:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60123 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbYKQXwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 18:52:43 -0500
Message-ID: <492203AE.7020206@zytor.com>
Date: Mon, 17 Nov 2008 15:52:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com
Subject: Re: [PATCH v2 2/5] x86: ia32_signal: introduce COPY_SEG_STRICT
References: <491E4101.7010405@ct.jp.nec.com> <492201F2.1060804@ct.jp.nec.com> <4922027A.4060805@ct.jp.nec.com>
In-Reply-To: <4922027A.4060805@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Impact: cleanup
> 
> Introduce COPY_SEG_STRICT for ia32_restore_sigcontext().
> 

I don't like the name _STRICT() for this; if anything it seems to have 
quite the opposite meaning.  I would suggest COPY_SEG_USER() or even 
COPY_SEG_CPL3().

	-hpa
