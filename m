Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbZBKWxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbZBKWxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbZBKWxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:53:10 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:43223 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbZBKWxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:53:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Je8DDcUWeoqtJ7oT68kxbdh2AiCwaP/7Y3S3E/M7LhB25JOUAQ01MUq+iQjfzhSjOZ
         jFkX8kEdkHvWzNilS+xpnA6DgsQ4rtFzkyTVzs1tHIsC2GNIxrxozGy7v6qmKAYP+/Ir
         HOMCwq2YvChzelWX26P281JDV0Stpo/nkJmuc=
Message-ID: <499356CF.2060706@gmail.com>
Date: Wed, 11 Feb 2009 23:53:03 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Brian Gerst <brgerst@gmail.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Use linker to offset symbols by __per_cpu_load
References: <1234105120-19731-1-git-send-email-brgerst@gmail.com> <1234105120-19731-2-git-send-email-brgerst@gmail.com> <20090209092951.GB7930@elte.hu>
In-Reply-To: <20090209092951.GB7930@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2009 10:29 AM, Ingo Molnar wrote:
> * Brian Gerst <brgerst@gmail.com> wrote:
> 
>> Impact: cleanup and bug fix
>>
>> Use the linker to create symbols for certain per-cpu variables
>> that are offset by __per_cpu_load.  This allows the removal of
>> the runtime fixup of the GDT pointer, which fixes a bug with
>> resume reported by Jiri Slaby.
>>
>> Signed-off-by: Brian Gerst <brgerst@gmail.com>
>> Cc: Jiri Slaby <jirislaby@gmail.com>
>> ---
>>  arch/x86/include/asm/percpu.h    |   22 ++++++++++++++++++++++
>>  arch/x86/include/asm/processor.h |    2 ++
>>  arch/x86/kernel/cpu/common.c     |    6 +-----
>>  arch/x86/kernel/head_64.S        |   21 ++-------------------
>>  arch/x86/kernel/vmlinux_64.lds.S |    8 ++++++++
>>  5 files changed, 35 insertions(+), 24 deletions(-)
> 
> applied to tip/core/percpu, thanks!
> 
> Also added these tags:
> 
> Reported-by: Jiri Slaby <jirislaby@gmail.com>
> Acked-by: Jiri Slaby <jirislaby@gmail.com>

Ok, fixes the problem for me, thanks.
