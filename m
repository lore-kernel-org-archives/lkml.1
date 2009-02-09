Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbZBINpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbZBINpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbZBINoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:44:25 -0500
Received: from mail-ew0-f26.google.com ([209.85.219.26]:56671 "EHLO
	mail-ew0-f26.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965AbZBINoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:44:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OGfsE6YY3QcZJ209MHyfHqjEQvKy6rYlwIJGSAtubDy1VPFEd5kje9esJfxyRUgVJ7
         Cw0YadCpxTgBBmGtPLtvR4ynu1AeKeNM7ck6r3HSfII0zCOvAuAjKRIGLxJwJMhSMtUd
         ulJz6Vdby4bvTU/WWw9YKx6UbZkbTxYNoKLPs=
MIME-Version: 1.0
In-Reply-To: <1233934630.17551.1.camel@think.oraclecorp.com>
References: <a4423d670902060710m4919f6d6p1ffae13859c891be@mail.gmail.com>
	 <1233934630.17551.1.camel@think.oraclecorp.com>
Date: Mon, 9 Feb 2009 16:44:20 +0300
Message-ID: <a4423d670902090544g7b7dbe9aj415141c46d1fc95f@mail.gmail.com>
Subject: Re: next-20090206: kernel BUG at mm/slub.c:1132
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-btrfs@vger.kernel.org,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/6 Chris Mason <chris.mason@oracle.com>:
> On Fri, 2009-02-06 at 18:10 +0300, Alexander Beregalov wrote:
>> Hi
>>
>> I run dbench on btrfs, which is on file on xfs
>>
>> btrfs: disabling barriers on dev /dev/loop/0
>> ------------[ cut here ]------------
>> kernel BUG at mm/slub.c:1132!
>> invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>> last sysfs file: /sys/kernel/uevent_seqnum
>
> Btrfs hammers on slab caches quite a lot, can you reproduce this without
> loop or without btrfs?
Hi Chris

No, I can not reproduce it without loop.
