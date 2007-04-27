Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbXD0PjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbXD0PjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbXD0PjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:39:22 -0400
Received: from smtp.bulldogdsl.com ([212.158.248.8]:1096 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755866AbXD0PjU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:39:20 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: "Sunil Naidu" <akula2.shark@gmail.com>
Subject: Re: Linux 2.6.21 - something wrong with dmesg.
Date: Fri, 27 Apr 2007 16:39:13 +0100
User-Agent: KMail/1.9.6
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Frederik Deweerdt" <deweerdt@free.fr>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <8355959a0704260514s39afa1ecj3e7e077e482769a8@mail.gmail.com> <200704261535.46568.s0348365@sms.ed.ac.uk> <8355959a0704270731k97da30anf1c010f7ae3dc18c@mail.gmail.com>
In-Reply-To: <8355959a0704270731k97da30anf1c010f7ae3dc18c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200704271639.13419.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 April 2007 15:31:37 Sunil Naidu wrote:
> On 4/26/07, Alistair John Strachan <s0348365@sms.ed.ac.uk> wrote:
> > > Don't you need to increase CONFIG_LOG_BUF_SHIFT ?
>
> Yep, I need to. But, have to enable the Kernel Debug (DEBUG_KERNEL) to
> increase the value from default 14 value to 15/16. I feel that this
> might increase the kernel size?

>From a quick grep, DEBUG_KERNEL will only increase the kernel size on PARISC 
(arch/parisc/mm/init.c), so setting it won't have any adverse affect on your 
kernel size (if you disable all the options under it).

> Ummm, is it possible to move CONFIG_LOG_BUF_SHIFT under the General
> Setup area? (say, down the Kernel .config support - IKCONFIG).

I agree with this. It's also quite interesting to see that one can enable 
DEBUG_KERNEL, increase CONFIG_LOG_BUF_SHIFT, and then disable DEBUG_KERNEL, 
and the changed value is still used.

I think it should be easier to change this value, as anybody with it set too 
low has a useless kernel log buffer and it can make reporting more difficult.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
