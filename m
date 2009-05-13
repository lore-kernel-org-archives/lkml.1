Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbZEMLSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbZEMLSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 07:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbZEMLSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 07:18:38 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:65346 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZEMLSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 07:18:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=A0LR8Ne0UGj5nzXEjK56CCT6ZI9H9SZ4chPtYDtkSkao2619egpWVKtbfYIKPzRebm
         Bb2tFgEazGLxYZo4PYwEeaScY85TgCSAu1aK+uqzjkJ5tIK/O6QYvw0pTan9Zwf32LIz
         j16zARP9/tYCQDIj86oXmzrMZQNzO13ahpsFY=
MIME-Version: 1.0
In-Reply-To: <87r5ytl0nn.fsf@basil.nowhere.org>
References: <20090513172904.7234.A69D9226@jp.fujitsu.com>
	 <87r5ytl0nn.fsf@basil.nowhere.org>
Date: Wed, 13 May 2009 20:18:38 +0900
X-Google-Sender-Auth: d986b27ea6137cce
Message-ID: <2f11576a0905130418w1782f85j12cb938e92d256ff@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED 
	submenu
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Minchan@firstfloor.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/13 Andi Kleen <andi@firstfloor.org>:
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:
>
>> Subject: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED submenu
>>
>> Almost people always turn on CONFIG_UNEVICTABLE_LRU. this configuration is
>> used only embedded people.
>> Thus, moving it into embedded submenu is better.
>
> Is there are any reason it cannot be just made unconditional unless
> CONFIG_MMU is disabled. It was never clear to me why this was a config
> option at all.

In past days, I proposed this. but Minchan found this config bloat kernel 7kb
and he claim embedded guys should have selectable chance. I agreed it.

Is this enough explanation?
