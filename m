Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbYGWWAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbYGWWAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 18:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYGWWAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 18:00:43 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:36292 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbYGWWAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 18:00:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GlItJFWAlfULqI3gCauLYNspvKaVooR0rx5PVrQhiRYA/tEa30kis1ViUqugMit6Dh
         R5itN+IOfb2585PQGo0SPQI+Mz3Z2om4zRd4TtjKR7HWkXaKBbg2pRJ0zT5zTiSSYqa2
         XNt8YzP5K3PVm5p6gb7HY9EK9+2Rdvfa9nD0A=
Message-ID: <19f34abd0807231500m3d780d90i39626023e0685369@mail.gmail.com>
Date: Thu, 24 Jul 2008 00:00:42 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dieter Ries" <clip3@gmx.de>
Subject: Re: Current Git: BUG: unable to handle kernel paging request at 0000000001a40ca0
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com, netdev@vger.kernel.org,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, jeffrey.t.kirsher@intel.com,
       e1000-devel@lists.sourceforge.net
In-Reply-To: <4887A860.6070607@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <488750AA.20707@gmx.de>
	 <19f34abd0807231046o4b194409w7d0e28a7cd745afa@mail.gmail.com>
	 <48877200.9040608@gmx.de> <4887A860.6070607@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 11:53 PM, Dieter Ries <clip3@gmx.de> wrote:
>>> Dieter: If this is reproducible, it would probably help quite a bit to
>>> configure the kernel with CONFIG_SLUB_DEBUG and boot with
>>> slub_debug=FZPUT (unless you already have CONFIG_SLUB_DEBUG_ON set, in
>>> which case you are already running with the SLUB debugging at boot).
>>> It might catch the corruption before it becomes fatal, or give us some
>>> more clues anyway.
>
> I tried to bisect the bug, which failed because there were too many kernels
> not booting with other problems, I guess bisecting just fails in the merge
> window.
>
> With CONFIG_SLUB_DEBUG_ON the output looks different, unfortunately
> netconsole stops before those are transmitted.
>
> As there are always some lines about e1000 in the backtraces, I tried to
> boot without LAN cable connected, and it worked, and crashed afterwards when
> I plugged the cable in, with a bug in net/core/dev.c.
>
> I will search on tomorrow, as it is getting quite late now.
>
> Should I copy the messages with CONFIG_SLUB_DEBUG_ON by hand, or are just
> some parts important?

There were some e1000 patches in flight on LKML recently; you might be
able to find them and see if it helps you. It also seems that some
changes were just committed to -git, so I guess you should try the
very latest from there.

You also Cced netdev from the start, so somebody from there should be
able to help you more from here than I. :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
