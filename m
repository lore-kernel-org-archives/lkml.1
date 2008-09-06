Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYIFRQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYIFRQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYIFRQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:16:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:44391 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbYIFRQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:16:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NA/u70C8Zo5IJl//O0O8PyFCJ/k1yHrVxedglRunH7DBYYxzQkYO3ESShDTLnpfamS
         fMj25a45H0r7x5vLBdWDLZKXU5564hDVgfOAiMOAXBSydNZ0V4vIL7/UwOtodEB2ptGP
         K9mAoi783VO9q3VY3Ex+vmdg5uD/PVJ+fKdrk=
Message-ID: <86802c440809061016n2fa6d8te0dd486ceeb6135d@mail.gmail.com>
Date: Sat, 6 Sep 2008 10:16:39 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] dyn_array: using %pF instead of print_fn_descriptor_symbol
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080906170944.GG4856@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220047669-15029-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080829152053.92fa6fd4.akpm@linux-foundation.org>
	 <86802c440808291532r15dd581cj3f69755985578c2b@mail.gmail.com>
	 <20080829155319.dc76b1c0.akpm@linux-foundation.org>
	 <20080906170944.GG4856@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2008 at 10:09 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> >     ptr = __alloc_bootmem_nopanic(total_size, max_align, 0);
>> >     if (!ptr)
>> >             panic("Can not alloc dyn_alloc\n");
>>
>> Why duplicate the panic()?  Just call __alloc_bootmem().
>
> agreed.
>
>> > #ifdef CONFIF_GENERIC_HARDIRQS
>>
>> That doesn't appear to have been very well tested?
>
> on non-genirq systems? Most likely. If then most testing they get is
> from cross-build tools. Few if any actual users.
>
>> The code has a few coding-style glitches which checkpatch can detect.
>
> yeah. Yinghai, could you please fix them?

already in tip/master and -mm
except  first one.

YH
