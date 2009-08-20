Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbZHTMCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbZHTMCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZHTMCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:02:50 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:62371 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbZHTMCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LpoKcBX4fK+bOaUONVUloiPC03LnEg/GuSnIHYqI6tCsIfax5tn3XIM2uinE/JIoIE
         +VmajYpHWULJ6ZcfwE794tbDLker+aaslSgrraVF/1K9ZLkqIkRbebayyBDJWWB8su3m
         +vuqMvdJbVfodENxXeIv8YhHh5a6c4jx03Khw=
MIME-Version: 1.0
In-Reply-To: <20090820111937.GF524@hash.localnet>
References: <20090820015624.GE524@hash.localnet>
	 <84144f020908192208x453ebbd4gecf52eb47903653d@mail.gmail.com>
	 <20090820111937.GF524@hash.localnet>
Date: Thu, 20 Aug 2009 14:02:49 +0200
Message-ID: <19f34abd0908200502n6ff53e71ld5bc18aa581d5625@mail.gmail.com>
Subject: Re: 2.6.32-rc6 BUG at mm/slab.c:2869!
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/20 Bob Copeland <me@bobcopeland.com>:
> On Thu, Aug 20, 2009 at 08:08:16AM +0300, Pekka Enberg wrote:
>> Someone is stomping on SLAB internal data structures. Ext4 appears in
>> both stack traces so I guess we should CC linux-ext4. How easy is it
>> to reproduce this bug? One option is to try kmemcheck to see if it
>> catches the problem (see Documentation/kmemcheck.txt for details).
>
> I don't yet have a way to reproduce at will but I've anecdotally hit
> this or some related bug 3 times in the last week or two without trying,
> I only now captured a stack trace.  I can try some workload to exercise
> the filesystem a bit more to see what turns up.
>
> I'll try that and kmemcheck next.

Hm, I'm afraid kmemcheck gives some known false positives related to
bitfields in ext4 code, so in the case that something turned up, it
might be hard to distinguish it from those false positives.

Sorry :-/


Vegard
