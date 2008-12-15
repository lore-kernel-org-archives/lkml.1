Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbYLOUJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbYLOUJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 15:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYLOUJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 15:09:28 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:61926 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbYLOUJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 15:09:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nqb2r04dYOIhS+la7C/GGXI9FtVDKbT8D9pFjAdo/icrdNeJBl8imBmZC3b+KGVU9f
         7QegtCHWOx7hi49ZbBHXFEK3fiLV+3etSwreNu+z+BSgL9zeihwSzdT2TI4mpW53jozk
         SDMjdLcvWAYLrWqft6riv0ExYFhpNQyxPZU1s=
Message-ID: <a4423d670812151209m7c0b6f99oc86dbc6d934fa084@mail.gmail.com>
Date: Mon, 15 Dec 2008 23:09:24 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: next-20081215: kernel BUG at block/cfq-iosched.c:1243
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081215184440.GI32491@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670812151029u5458f9b4iaa36316a5f210ff1@mail.gmail.com>
	 <20081215183235.GG32491@kernel.dk>
	 <a4423d670812151038p4bab739fo3a6f9afd1ad3e358@mail.gmail.com>
	 <20081215184440.GI32491@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/15 Jens Axboe <jens.axboe@oracle.com>:
> On Mon, Dec 15 2008, Alexander Beregalov wrote:
>> 2008/12/15 Jens Axboe <jens.axboe@oracle.com>:
>> >> [   23.080733] kernel BUG at block/cfq-iosched.c:1243!
>> >> [   23.080733] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>>
>> > Odd, is it reproducible? What is your .config?
>> Yes, it is
>>
>> Config is in attach
>
> It's weird, because the only change for CFQ in that area is the one
> below. Does the oops go away if you back this out?
Yes, it can boot without the patch, no oops.

> From 030a3f02bb42fad91ae84c99924fe3ee162a634d Mon Sep 17 00:00:00 2001
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Fri, 12 Dec 2008 15:56:31 +0100
> Subject: [PATCH] cfq-iosched: fix race between exiting queue and exiting task
