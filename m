Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbZEEIFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbZEEIFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 04:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbZEEIFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 04:05:12 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:35816 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbZEEIFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 04:05:09 -0400
Date: Tue, 5 May 2009 10:05:05 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: xfs-masters@oss.sgi.com
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: fs/xfs/xfs_mount.c:1483: warning: array subscript is above array
 bounds
Message-ID: <Pine.LNX.4.64.0905051001260.4192@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


http://kisskb.ellerman.id.au/kisskb/buildresult/407608/:
fs/xfs/xfs_mount.c:1483: warning: array subscript is above array bounds

xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
{
	xfs_sb_field_t  f;

	...
	first = xfs_sb_info[f].offset;
	...
}

xfs_sb_field_t is an enum with 47 values.
xfs_sb_info[] has at least 47 entries.

Is this a bogus warning?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
