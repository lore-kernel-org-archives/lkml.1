Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYICVfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYICVfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYICVfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:35:03 -0400
Received: from nebensachen.de ([195.34.83.29]:46138 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbYICVfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:35:01 -0400
X-Hashcash: 1:20:080903:bzolnier@gmail.com::vHhaOEHURQde1Nop:00000000000000000000000000000000000000000000PaT
X-Hashcash: 1:20:080903:alan@lxorguk.ukuu.org.uk::uwpyfIrF2nYpUAAM:00000000000000000000000000000000000000XMf
X-Hashcash: 1:20:080903:akpm@linux-foundation.org::hLvW6/iSMIyYILQd:0000000000000000000000000000000000001uwz
X-Hashcash: 1:20:080903:jeff@garzik.org::SfNTy70y0Kn9SjZq:00Ise9
X-Hashcash: 1:20:080903:randy.dunlap@oracle.com::0a8ImyiAEA110u6I:0000000000000000000000000000000000000037CV
X-Hashcash: 1:20:080903:htejun@gmail.com::lP5ZNsvv9U63ZQYB:003xd
X-Hashcash: 1:20:080903:linux-ide@vger.kernel.org::Hcvhb97tkKZuiqt8:0000000000000000000000000000000000003m7J
X-Hashcash: 1:20:080903:linux-kernel@vger.kernel.org::DhFN4GUWoaU7TSf3:00000000000000000000000000000000062bA
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ide: Implement disk shock protection support
References: <87wshzplvk.fsf@denkblock.local>
	<20080829211345.4355.93873.stgit@denkblock.local>
	<200809012129.14979.bzolnier@gmail.com>
	<87ljy90zin.fsf@denkblock.local>
Date: Wed, 03 Sep 2008 23:33:39 +0200
In-Reply-To: <87ljy90zin.fsf@denkblock.local> (Elias Oltmanns's message of
	"Wed, 03 Sep 2008 22:01:52 +0200")
Message-ID: <8763pc29u4.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns <eo@nebensachen.de> wrote:
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
[...]
>> Also could you please move the new code to a separate file (i.e.
>> ide-park.c) instead of stuffing it all in ide.c?
>
> This is probably a sensible idea especially since there may be more once
> we go ahead with the in-kernel solution.

Sorry, I forgot to mention that I haven't a clue as to what headers to
include explicitly in such a file. Actually, ide-park.c compiles on my
system just with ide.h included. This would, however, be an unsuitably
minimal approach, I fear. Some advice would be most welcome.

Regards,

Elias
