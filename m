Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYGQGiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYGQGiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 02:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbYGQGiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 02:38:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:27678 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYGQGiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 02:38:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ArFld1nfuMHdPJCZ9PjcCqaBHXnPG1+47Vgvo5pO9bxrtr97Si0d2UUZPbkKOM0Yv3
         e8g69eZxuMvu8R3NwbAcPiKQdwQ6ilmVw1sACHBHJWFW/j9KGco+i3u7sXxw0sSXYsrv
         THuwSArJBtHVOVN0iWILe0zkXfzFRbbwlsYog=
Message-ID: <1ba2fa240807162338n3cec63f8u8e227c7e4bd05825@mail.gmail.com>
Date: Thu, 17 Jul 2008 09:38:10 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: [GIT PULL] MMC updates for 2.6.26
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080717004127.388aa574@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080715160436.0f6ac19e@mjolnir.drzeus.cx>
	 <alpine.LFD.1.10.0807161512030.2835@woody.linux-foundation.org>
	 <20080717004127.388aa574@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 1:41 AM, Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> On Wed, 16 Jul 2008 15:16:26 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>>
>>
>> On Tue, 15 Jul 2008, Pierre Ossman wrote:
>> >
>> >  45 files changed, 6054 insertions(+), 1320 deletions(-)
>>
>> If you had done the "--summary", you'd also have seen these bogus:
>>
>>        mode change 100644 => 100755 drivers/mmc/core/sdio_io.c
>>        mode change 100644 => 100755 include/linux/mmc/sdio_func.h
>>
>> entries.
>>
>> I have no idea why you think those things should be executable, but it
>> happened in commit 6d37333163025b46afbcad434ec9a5f2e88e7254 ("mmc: fix
>> sdio_io sparse errors").
>>
>
> Ouch. It was in the patch submitted to me, but I overlooked the mode
> changes there. I wasn't fully aware git could express such things in
> the patches. :)
>
>> Anyway, there's a reason why I ask people to use
>>
>>       --diffstat --summary -M
>>
>> when generating the report. This is just part of it.
>>
>> I fixed it up in the merge, so it's ok in my tree, but I thought I'd point
>> it out.
>>
>
> Thanks. I have changed my scripts and hopefully I'll notice such
> silliness in the future.
>
> Rgds
> --
>     -- Pierre Ossman

I take the blame on me. I've copied that file between OSes so it
changed executable. It slipped from my attention
Will also change my scripts as well.

Tomas
