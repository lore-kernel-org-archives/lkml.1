Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbZLVBJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbZLVBJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 20:09:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbZLVBJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 20:09:08 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:64326 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbZLVBI5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 20:08:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=krC0qrRTR80+EXEYc3J0Y6sk/ql13WIKNowf99hDNFmhjod8cwvvKgdVui2Fwxxbgj
         Q5h+d3tzfIAGAhc9erT6+y0eNB451LsSNbYdplC3M9p/qr4RUlv9543pi42KgoWXA7Ke
         f5kO/lzUxwuBk1tJ+5KStcpr8xMt777+Wk3qM=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.0912220859060.1686@darkstar.example.net>
References: <alpine.LNX.2.00.0912211855460.1689@darkstar.example.net>
	 <4B30134C.1050609@gmail.com>
	 <alpine.LNX.2.00.0912220859060.1686@darkstar.example.net>
Date: Mon, 21 Dec 2009 19:08:56 -0600
Message-ID: <51f3faa70912211708j200ab584wa835ffe50981415e@mail.gmail.com>
Subject: Re: 2.6.32.2 SATA link detect failed, 2.6.32.1 works fine
From: Robert Hancock <hancockrwd@gmail.com>
To: fengxiangjun <fengxiangjun@neusoft.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 7:02 PM, fengxiangjun <fengxiangjun@neusoft.com> wrote:
>
> Yeah, running 2.6.32.1 now, no problem.
>
> dmesg shows:
>
> ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>
> When booting 2.6.32.2 with the same config, I get
>
> ata1.00: SATA link down (SStatus 0 SControl 301)
>
> Weird.

CCing linux-ide and Tejun. Could be some kind of timing difference
triggering the problem, perhaps?

>
> On Mon, 21 Dec 2009, Robert Hancock wrote:
>
>> On 12/21/2009 05:12 AM, fengxiangjun wrote:
>> >
>> > Hi,
>> >
>> > after upgrading to 2.6.32.2,
>> > with the attached config,
>> > kernel booting always(just tried 10+ times) failed at:
>> >
>> > ata1.00: SATA link down (SStatus 0 SControl 301)
>> > ...
>> > VFS: Cannot open root device ...
>>
>> There were no libata changes in 2.6.32.2 that should have affected this. Are
>> you sure the .config is unchanged? Have you rechecked that 2.6.31.1 still
>> works?
>>
> ---------------------------------------------------------------------------------------------------
> Confidentiality Notice: The information contained in this e-mail and any accompanying attachment(s)
> is intended only for the use of the intended recipient and may be confidential and/or privileged of
> Neusoft Corporation, its subsidiaries and/or its affiliates. If any reader of this communication is
> not the intended recipient, unauthorized use, forwarding, printing,  storing, disclosure or copying
> is strictly prohibited, and may be unlawful.If you have received this communication in error,please
> immediately notify the sender by return e-mail, and delete the original message and all copies from
> your system. Thank you.
> ---------------------------------------------------------------------------------------------------
>
>
