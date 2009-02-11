Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbZBKPPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbZBKPPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 10:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbZBKPO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 10:14:58 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:19615 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZBKPO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:14:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=jiAouuRp/HDll1igTbvE4/J1WtiWBEsgsxN9GEs9KSoDNSimVymGbHP7XjwnnuSrgC
         MerxRhGtpFWWLqWDxrTJIiGJv11Q0OCh/OD4J8sogcFiSBvA1x7Gz1QpMKzU5ioePsuH
         inCLsVeM3miv7uPUuhw+RM/+Ai5LE0EmtzxFM=
Message-ID: <4992EB62.3000501@gmail.com>
Date: Thu, 12 Feb 2009 00:14:42 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Pass in pt_regs pointer for syscalls that need
 	it
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com>	 <1234277507-4987-3-git-send-email-brgerst@gmail.com>	 <4992812B.1050800@kernel.org>	 <73c1f2160902110631j68e58202h3e49288cfe613d66@mail.gmail.com>	 <4992E396.6000205@kernel.org> <4992E551.4060901@gmail.com>	 <73c1f2160902110659i776e1d89qc23d89363881572e@mail.gmail.com>	 <4992E92C.5000000@gmail.com> <73c1f2160902110710u77a563bftf09c460fab6f9136@mail.gmail.com>
In-Reply-To: <73c1f2160902110710u77a563bftf09c460fab6f9136@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> x86-64 doesn't have the tail-call problem because it doesn't use the
> pt_regs on stack trick for syscall args.  All the args are passed in
> registers.

Yeah, I was saying that we can do about the same thing on x86_32 by
passing in pointer to pt_regs and defining proper syscall wrappers.
It will cost a bit of performance by increasing register pressure tho.

-- 
tejun
