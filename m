Return-Path: <linux-kernel-owner+w=401wt.eu-S1759912AbYDTTp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbYDTTp5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 15:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbYDTTpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 15:45:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:3120 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbYDTTpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 15:45:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=WjKfbofYLfXrG/XkaeIqrxF6+op8LM3BTwvKTo9NDui3aYpiyYv3yXV1skaEhwi9ErUErGn6HSLGekeSMfoskSa3AmZK3lD5FBmKM70VBfmArBBIIYltXIy28gjo6WNQ4PbBHiNmxVBRuUdsYeQS4ziTskaTMUTN6ahuYyLS1UM=
Message-ID: <480B9D67.7060606@gmail.com>
Date: Sun, 20 Apr 2008 23:45:43 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: remove unused code and data in nexgen.c
References: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com>	<1208660074-7324-3-git-send-email-dmitri.vorobiev@gmail.com>	<480AC505.1030301@zytor.com> <877ies9x6b.fsf@basil.nowhere.org> <480B9856.3040902@gmail.com> <480B9ADD.9060105@zytor.com>
In-Reply-To: <480B9ADD.9060105@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin пишет:
> Dmitri Vorobiev wrote:
>>>
>>> Also NexGen was never shipped anyways, but bought by AMD and became
>>> the K6. So I assume whatever this file is supposed to do is done
>>> by amd.c anyways.
>>
>> IOW, you claim that now it's safe enough to throw away the NexGen
>> altogether?
>>
> 
> If it never shipped, then yes, it should be safe to remove.  We don't
> support other vendors that never went to product, e.g. RISE or Montalvo.

OK, then please drop this patch from the series (the other changes are OK,
I presume), and I'll try to take care of NexGen removal with a separate patch.

Thanks,
Dmitri

> 
>     -hpa
> 

