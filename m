Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbYKLMjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbYKLMjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYKLMix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:38:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41042 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbYKLMiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:38:52 -0500
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: ia32_signal: remove unnecessary padding
From: Andi Kleen <andi@firstfloor.org>
References: <491A48E9.8020909@ct.jp.nec.com> <491A496B.5010505@ct.jp.nec.com>
Date: Wed, 12 Nov 2008 13:56:21 +0100
In-Reply-To: <491A496B.5010505@ct.jp.nec.com> (Hiroshi Shimamoto's message of "Tue, 11 Nov 2008 19:11:39 -0800")
Message-ID: <878wrpdrwq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> writes:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>
> Impact: cleanup

Actually it's not a cleanup.

> Remove unnecessary paddings, this saves 4 bytes.

This might actually break code. The code is not actually used,
but only kept around because some old gdb versions used this
code as a marker for detecting signals.

I don't know if they require the padding or not, but it seems
somewhat risky to change a legacy marker like this.

-Andi

-- 
ak@linux.intel.com
