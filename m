Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbYKBVT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbYKBVT0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 16:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbYKBVSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 16:18:40 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:44729 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbYKBVSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:18:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GVs4NVFTeMQiJ6FZhSOwP2XVaiQSErcD8IU7Pqt0fqSQ7Hk+6gvVk8fc7hwj4AdG7L
         NOQWKtdL/v5PgX0pi8dolYjImHShlMduImfEh/dTTFCncMACG/zLXemK3x0Vq6qr4BxY
         oIUKRW1plFp2YDTA1MISEUVIoO2q5uzoR+K/s=
Message-ID: <19f34abd0811021318k22ee25edgdb896ffc9037031e@mail.gmail.com>
Date: Sun, 2 Nov 2008 22:18:36 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11852] v2.6.28-rc1: Regression in ext3/jbd
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Hidehiro Kawai" <hidehiro.kawai.ez@hitachi.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <wOAXuecskPD.A.JtG.pkeDJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
	 <wOAXuecskPD.A.JtG.pkeDJB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 2, 2008 at 5:07 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11852
> Subject         : v2.6.28-rc1: Regression in ext3/jbd
> Submitter       : Vegard Nossum <vegard.nossum@gmail.com>
> Date            : 2008-10-25 11:22 (9 days old)
> References      : http://marc.info/?l=linux-kernel&m=122493379905812&w=4
> Handled-By      : Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> Patch           : http://marc.info/?l=linux-kernel&m=122510792614388&w=4
>                  http://marc.info/?l=linux-kernel&m=122510828015045&w=4

This is in mainline as of

commit ef2cabf7c6d838eb0ee2b4fb8ef84f7c06ce16d9
Author: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Date:   Mon Oct 27 22:53:05 2008 -0400

    ext4: fix a bug accessing freed memory in ext4_abort

commit 44d6f78756560e95903de239e10f8a40a6eae444
Author: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Date:   Mon Oct 27 22:51:46 2008 -0400

    ext3: fix a bug accessing freed memory in ext3_abort

Thanks for quick action, by the way :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
