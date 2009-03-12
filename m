Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbZCLLtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbZCLLtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbZCLLsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:48:54 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:37211 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbZCLLsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:48:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nz4n4jJpUKxyiU0yHeCFvbjYSJCuwXQX+l0Ws9UPjqJqtPtxVjutIlICuMFAFdMW5M
         79MomjAHr4OkQaUu1pDsL00tZ5UEI/Ew5+nD2K0WrksinCZB5W1iXi64fr03CohUiGJx
         N5/Tf/52z1UXiq+hY6LEpAtNn0sDb558hjPHU=
MIME-Version: 1.0
In-Reply-To: <e2dc2c680903120438i27e209c2h28c61704299b8b4f@mail.gmail.com>
References: <20090311114353.GA759@localhost>
	 <e2dc2c680903110516v2c66d4a4h6a422cffceb12e2@mail.gmail.com>
	 <20090311122611.GA8804@localhost>
	 <e2dc2c680903120053w37968c1cy556812cef63f0896@mail.gmail.com>
	 <20090312075952.GA19331@localhost>
	 <e2dc2c680903120104h4d19a3f6j57ad045bc06f9a90@mail.gmail.com>
	 <20090312081113.GA19506@localhost>
	 <e2dc2c680903120117j7be962b2xd63f3296f8f65a46@mail.gmail.com>
	 <20090312103847.GA20210@localhost>
	 <e2dc2c680903120438i27e209c2h28c61704299b8b4f@mail.gmail.com>
Date: Thu, 12 Mar 2009 12:48:50 +0100
Message-ID: <e2dc2c680903120448q386f84a4t5667e22751002ae9@mail.gmail.com>
Subject: Re: Memory usage per memory zone
From: jack marrow <jackmarrow2@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Sure, but something is unreclaimable... Maybe some process is taking a
>> lot of shared memory(shm)? What's the output of `lsof`?
>
> I can't paste that, but I expect oracle is using it.

Maybe this is helpful:

#  ipcs |grep oracle
0x00000000 2293770    oracle    640        4194304    22
0x00000000 2326539    oracle    640        536870912  22
0x880f3334 2359308    oracle    640        266338304  22
0x0f9b5efc 1933312    oracle    640        44
