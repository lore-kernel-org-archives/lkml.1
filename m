Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYKUQwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYKUQwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755468AbYKUQwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:52:06 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:23372 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbYKUQwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:52:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VZBn7ffZ24YVMnK0JQ1Y2XbkErFE1hBiFb6LBPZCEx2f7iuILZXjjWWEIn5BKtTtVl
         R1d6BsrJ9nfpddUf8onz6KN9DmtoCcRLAu/SmEVSmFHRh2FCq5G7WXSAiDFu9IBcXD3U
         fcud0RydNOSduOi6pn/ulbTcahTv6LFWCnDmo=
Message-ID: <a4423d670811210852q739a3929g23a0476927bbcc11@mail.gmail.com>
Date: Fri, 21 Nov 2008 19:52:02 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: next-20081117: kernel freezes with netconsole enabled
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, satyam.sharma@gmail.com
In-Reply-To: <1227119251.3149.57.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081119175740.GE12456@orion> <1227119251.3149.57.camel@calx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/19 Matt Mackall <mpm@selenic.com>:
> On Wed, 2008-11-19 at 20:57 +0300, Alexander Beregalov wrote:
>> Hi
>>
>> It is x86_64 SMP
>> The kernel freezes while transferring kernel log through netconsole,
>> SysRq does not work at that moment.
>
> Does it survive if you boot with 'quiet'? Is this new behavior or have
> you successfully used netconsole before?

`queit` parameter does not help. The problem happens on 2.6.28-rc6 and
2.6.27 as well.
I will try older kernels next week.
