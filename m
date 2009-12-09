Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbZLINba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbZLINba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 08:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbZLINb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 08:31:29 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36018 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbZLINb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 08:31:28 -0500
Message-ID: <4B1FA6B6.8070701@cs.helsinki.fi>
Date: Wed, 09 Dec 2009 15:31:34 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] kmemcheck: make bitfield annotations truly no-ops when
 disabled
References: <1260121333-19642-1-git-send-email-vegard.nossum@gmail.com> <20091207141356.9e83fd5b.akpm@linux-foundation.org>
In-Reply-To: <20091207141356.9e83fd5b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton kirjoitti:
> On Sun,  6 Dec 2009 18:42:13 +0100
> Vegard Nossum <vegard.nossum@gmail.com> wrote:
> 
>> It turns out that even zero-sized struct members (int foo[0];) will affect
>> the struct layout, causing us in particular to lose 4 bytes in struct sock.
>>
>> This patch fixes the regression in CONFIG_KMEMCHECK=n case.
> 
> Which kernel version is the regression relative to?

AFAICT, it dates back to 2.6.31 when kmemcheck was introduced in 
mainline. Vegard?

> Should we backport this into 2.6.32.x?

I guess so. Eric, how bad is the regression?

			Pekka
