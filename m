Return-Path: <linux-kernel-owner+w=401wt.eu-S1763108AbZGABh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763108AbZGABh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760640AbZGABhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 21:37:13 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:62128 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758807AbZGABhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 21:37:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TEShYiV9TK+CVqtn+K+iuf2RQ/JiR4j4EX+Y4LJ+xUtxzGhb6ncsZzLi60hz8b/e/M
         3RU035oCXG0wSLQVCjcFCTEYIHsHVOcADiOoLnnOHiMkTB9pHaVgd1wDhA2Bn+42hovm
         RBvi/M/XyjWxHIXqJy0Afly32O3VJV9fPPCjM=
Message-ID: <4A4ABE06.1030907@gmail.com>
Date: Tue, 30 Jun 2009 19:38:14 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Zoltan Bus <zoltan.bus@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Problem with wake_up using real-time scheduling
References: <233789ed0906300144q209886b3qfb6737175a3660a0@mail.gmail.com>
In-Reply-To: <233789ed0906300144q209886b3qfb6737175a3660a0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2009 02:44 AM, Zoltan Bus wrote:
> Hello,
>
> I have a problem on kernel 2.6.26.3. I have a real-time task which
> uses the select system call to poll my audio driver. The sleeping task
> is waken up by wake_up() from an interrupt handler.
> The problem is, that the wake_up() function  sometimes does not wake
> up the task if real-time priority is used.
>
> The try_to_wake_up() returns from the out_running section, because of the check
>
>        if (p->se.on_rq)
>                goto out_running;
>
> There are no other tasks running when the poll function is called.
>
> Is this a known problem? Is it fixed somehow in newer versions?
> Unfortunately I do not have the possibility to change the newest kernel version.
> I am a newbie at linux, thank you very much for your help.

Most likely there is something you're doing wrong in your driver, we 
would have to see the source code to give many useful suggestions..
