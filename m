Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbYFTVTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbYFTVTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYFTVTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:19:34 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:15908 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbYFTVTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:19:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=l6DxDYHVkyrr7E/GgqdQK6jk67p+p1Xn9gxwPL+EeAmND6Btw9TaRrOplnkKCmAmOv
         XFdZzKbvZi0PT3DChf79cvi+576L1PI3xl9Kb0qdqTGA5hX1N7RiNeJzeYfLmAV5EOB1
         lRCiSYU0LzCEsJY/5Vs3YMIL1FpBejuW6bqgU=
Message-ID: <a4423d670806201419i2f0c0982j69eb423f9ecd239d@mail.gmail.com>
Date: Sat, 21 Jun 2008 01:19:29 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: 2.6.26-rc: SPARC: Sun Ultra 10 can not boot
Cc: kernel-testers@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080619.190048.193701955.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670806190707k7ae6da8cud80a826a1603d941@mail.gmail.com>
	 <a4423d670806190902l48c542e0i6a7380a2d3e7f520@mail.gmail.com>
	 <20080619.190048.193701955.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/20 David Miller <davem@davemloft.net>:
> When you revert that changeset, there is a loop in the backtrace of
> all kernel threads, and therefore lockdep turns itself off when all of
> the stack backtrace slots get consumed by that loop in the backtraces.
>
> After the revert you should see a set of kernel messages like:
>
> BUG: MAX_STACK_TRACE_ENTRIES too low!
> turning off the locking correctness validator.
>
> and that would confirm my theory.

No, I do not have such messages.
Does it mean that we need different explanation?
