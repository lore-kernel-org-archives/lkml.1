Return-Path: <linux-kernel-owner+w=401wt.eu-S1760197AbYDTUEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbYDTUEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 16:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756324AbYDTUEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 16:04:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33892 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188AbYDTUEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 16:04:36 -0400
Message-ID: <480BA19C.8090608@firstfloor.org>
Date: Sun, 20 Apr 2008 22:03:40 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: remove unused code and data in nexgen.c
References: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com>	<1208660074-7324-3-git-send-email-dmitri.vorobiev@gmail.com>	<480AC505.1030301@zytor.com> <877ies9x6b.fsf@basil.nowhere.org> <480B9856.3040902@gmail.com> <480B9ADD.9060105@zytor.com>
In-Reply-To: <480B9ADD.9060105@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
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
> If it never shipped, then yes, it should be safe to remove. 

It was shipped as AMD K6, but I have no idea if this file is supposed
to handle real k6s or just early nexgen engineering samples.

But since it has been basically broken forever (or at least for 
all of 2.6) it is probably safe to remove until someone complains.

-Andi
