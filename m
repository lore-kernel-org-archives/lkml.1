Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbXKTGtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbXKTGtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbXKTGtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:49:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33926 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbXKTGte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:49:34 -0500
Message-ID: <4742831F.9040408@zytor.com>
Date: Mon, 19 Nov 2007 22:47:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: David Miller <davem@davemloft.net>, xiyou.wangcong@gmail.com,
       goodmenkernel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Is there any word about this bug in gcc ?
References: <E1IuMnZ-0003o3-00@gondolin.me.apana.org.au>
In-Reply-To: <E1IuMnZ-0003o3-00@gondolin.me.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> David Miller <davem@davemloft.net> wrote:
>> Because the compiler knows things about the inputs and can
>> thus apply optimizations that a static implementation in glibc
>> that has to handle all forms of inputs cannot.
> 
> On an unrelated note, I wonder if distros will be treating this
> with the same level of urgency as security vulnerabilities,
> especially in light of Shamir's recent note on maths errors.
> 

This one is definitely messy.  There is absolutely no way to know what 
gcc has miscompiled.  It looks to me that both gcc 4.2 and 4.3 are 
affected, any others?

	-hpa
