Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbZFKNPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbZFKNPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZFKNPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:15:32 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:60963 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZFKNPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:15:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RDPn9bAr1/0gdG9dgICWZe76qVzmadqzY2KizT+5fpEOhKDfksRsJOyoM5CFZgELD8
         Q9POGnrwjpJ1MJmre0eMll739hb8NXE1r7gS4ps+usD1dt6IK43wabJddrKhUil0Fv0g
         3M4RudlvJw7Q7xlqQwzkn1hS5uBh/m2aoCOyY=
MIME-Version: 1.0
In-Reply-To: <84144f020906110612t3102efdev39e77b6429013176@mail.gmail.com>
References: <a4423d670906110603s42bf0287p848b00c2cc786cc1@mail.gmail.com>
	 <84144f020906110612t3102efdev39e77b6429013176@mail.gmail.com>
Date: Thu, 11 Jun 2009 17:15:32 +0400
Message-ID: <a4423d670906110615q10579f17u5b870fc4b1cd977@mail.gmail.com>
Subject: Re: next-20090611: SLUB: Unable to allocate memory on node -1
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-next <linux-next@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/11 Pekka Enberg <penberg@cs.helsinki.fi>:
> On Thu, Jun 11, 2009 at 4:03 PM, Alexander
> Beregalov<a.beregalov@gmail.com> wrote:
>> Hi
>
> There should be a stack trace here printed out by the page allocator.
> Can you post that too?

I do not see it:
[ 1626.596025] git used greatest stack depth: 1864 bytes left
[ 2396.398829] pdflush used greatest stack depth: 1696 bytes left
[ 7378.179886] SLUB: Unable to allocate memory on node -1 (gfp=11200)
[ 7378.182599]   cache: kmalloc-2048, object size: 2048, buffer size:
2048, default order: 3, min order: 0
[ 7378.182599]   node 0: slabs: 407, objs: 1724, free: 0
[ 7378.426463] SLUB: Unable to allocate memory on node -1 (gfp=11200)
[ 7378.429764]   cache: kmalloc-2048, object size: 2048, buffer size:
2048, default order: 3, min order: 0
[ 7378.429764]   node 0: slabs: 407, objs: 1724, free: 0
[11541.347736] SysRq : Show Memory
