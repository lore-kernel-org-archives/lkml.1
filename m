Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbYDTTYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbYDTTYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 15:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbYDTTYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 15:24:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:33014 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbYDTTYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 15:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=h/wqi1U1+vzLzWJ1gvMup9wXcbhaXZMbmOFf0MRp6N3fRKK502UEt+ElbuPFNf9SLcb32SNQ02rFJDm1urErcPS5zi2Ql+koZapMcnvXxcQOwrvYSmnnEnmFL79xpiQaIdrJcnvzXlJVCFAbmylQF4PDnrkQ5EXXsVrri3DRsEI=
Message-ID: <480B9856.3040902@gmail.com>
Date: Sun, 20 Apr 2008 23:24:06 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: remove unused code and data in nexgen.c
References: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com>	<1208660074-7324-3-git-send-email-dmitri.vorobiev@gmail.com>	<480AC505.1030301@zytor.com> <877ies9x6b.fsf@basil.nowhere.org>
In-Reply-To: <877ies9x6b.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen пишет:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
>> Dmitri Vorobiev wrote:
>>> Nobody calls the function nexgen_init_cpu(), therefore it
>>> can be removed. The variable nexgen_cpu_dev is used only by
>>> this function, so this patch removes useless data as well.
>>> This patch was build-tested using defconfigs for i386 and x86_64.
>>> It also survived a few randconfig instances for i386. Runtime
>>> tests were performed by booting 32-bit and 64-bit x86 boxen up to
>>> the shell prompt.
>> NAK.  This is broken.
>>
>> The reason nexgen_cpu_dev is unreferenced is because the file is
>> missing a cpu_vendor_dev_register(), which should be added.
> 
> If we did that long without it wouldn't it be better to just remove it?
> 
> Also NexGen was never shipped anyways, but bought by AMD and became
> the K6. So I assume whatever this file is supposed to do is done
> by amd.c anyways.
> 

IOW, you claim that now it's safe enough to throw away the NexGen
altogether?

Dmitri

> -Andi
> 

