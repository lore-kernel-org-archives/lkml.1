Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758226AbYLQE27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbYLQE27 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 23:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYLQE2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 23:28:48 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:33996 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYLQE2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 23:28:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=m6HH1s3Kk0pAVB26Ce2PutOyDo7/tSOsxdkVmJW/mRxUaVBkAFbb+8pHV3Tf2QQ0xq
         cAyGOuk6l9jAzO7/vj31SEvjftwfu3TsuDNASdjm9IRwLzgvJzWe5IHS8IHxz1t5UGz1
         DlZoKltHnbqtoDu7TUAdtbCmOsu1dEsOq6eZ0=
Message-ID: <3f9a31f40812162028j5a0e12f5h2215daae12ce3441@mail.gmail.com>
Date: Wed, 17 Dec 2008 09:58:47 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: traps.c declare functions before they get used
Cc: "Jaswinder Singh" <jaswinder@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <20081216201956.GA14505@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229360145.15326.5.camel@jaswinder.satnam>
	 <20081216201956.GA14505@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Wed, Dec 17, 2008 at 1:49 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> +#ifndef CONFIG_MATH_EMULATION
>>  asmlinkage void math_emulate(long);
>>  #endif
>
> uhm, shouldnt that #ifndef CONFIG_MATH_EMULATION be #ifdef
> CONFIG_MATH_EMULATION?
>

Sorry, but it seems correct to me in traps case will be opposite.

If someone tries to access math_emulate() and MATH_EMULATION is not
defined then he will be trapped ;-)

Thank you,

Jaswinder Singh.
