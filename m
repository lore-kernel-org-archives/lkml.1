Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab0BRM3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 07:29:52 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:38926 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab0BRM3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 07:29:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=uQBzcBf9Km3DbDa7M4G5LAfhVFBXeHU6Ht78YqsVJYtYwyhWeO1f65euUaAuThR1jr
         aXjZ60v7h/McGolHIHzOZT3o/Z5Ot9Bo57DJ9+wX/vD0aC2dkpuPchmBX3577iDyJpyH
         28NGI9ix1ZtreCQvG0EnP7ysyAbrLGzEQThzw=
MIME-Version: 1.0
In-Reply-To: <1266490846.26719.206.camel@laptop>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
	 <1266488742.26719.119.camel@laptop>
	 <ff13bc9a1002180250t5c9acb54ib8609b4e752520c5@mail.gmail.com>
	 <1266490846.26719.206.camel@laptop>
Date: Thu, 18 Feb 2010 13:29:47 +0100
X-Google-Sender-Auth: 32c4b19fb7c1a20e
Message-ID: <ff13bc9a1002180429p3afc7313sfb65e980b3c198f2@mail.gmail.com>
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
From: Luca Barbieri <luca@luca-barbieri.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If we use the stack instead of per-CPU variables, all IRQs and NMIs
>> preserve CR0 and the SSE registers, so this would be safe, right?
>
> You'd have to take special care to deal with nested IRQs I think.

Could you elaborate on that?
Which issue could there be with nested IRQs?
