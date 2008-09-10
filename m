Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbYIJWk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbYIJWk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYIJWkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:40:49 -0400
Received: from nebensachen.de ([195.34.83.29]:38914 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbYIJWks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:40:48 -0400
X-Hashcash: 1:20:080910:steven@uplinklabs.net::VqlNt2AdhTXLXaPg:00000000000000000000000000000000000000004rdm
X-Hashcash: 1:20:080910:bzolnier@gmail.com::gid7i5E66/+jw1o/:00000000000000000000000000000000000000000000trC
X-Hashcash: 1:20:080910:linux-kernel@vger.kernel.org::SpxhlM2qbnAR7lV+:0000000000000000000000000000000001Bxe
X-Hashcash: 1:20:080910:mingo@elte.hu::+NtKmzsldEw3Ssmz:00001D+9
From: Elias Oltmanns <eo@nebensachen.de>
To: "Steven Noonan" <steven@uplinklabs.net>
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] drivers/ide/ide-probe.c: uninitialized variable 'rc'
References: <1220994461-15962-1-git-send-email-steven@uplinklabs.net>
	<200809102309.34159.bzolnier@gmail.com>
	<f488382f0809101419y65b35547t572a0f7bb5316952@mail.gmail.com>
Date: Thu, 11 Sep 2008 00:40:23 +0200
In-Reply-To: <f488382f0809101419y65b35547t572a0f7bb5316952@mail.gmail.com>
	(Steven Noonan's message of "Wed, 10 Sep 2008 14:19:56 -0700")
Message-ID: <87myifmxpk.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven Noonan" <steven@uplinklabs.net> wrote:
> On Wed, Sep 10, 2008 at 2:09 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
>>
>
>> I recall seeing identical patch before:
>>
>>        http://article.gmane.org/gmane.linux.ide/33107
>>
>> Does the existing code really results in gcc warning?
>>
>>
>
> Yes, because GCC thinks it's possible that the for loop has zero
> iterations (and hence, 'rc' is never touched).

What about changing the declaration to

	int i, uninitialized_var(rc);

then?

Regards,

Elias
