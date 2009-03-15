Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbZCODXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbZCODXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 23:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbZCODXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 23:23:06 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:51529 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbZCODXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 23:23:05 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] deadlock when swapping to FAT
References: <Pine.LNX.4.64.0903120819010.26206@hs20-bc2-1.build.redhat.com>
	<87zlfqohfn.fsf@devron.myhome.or.jp>
	<Pine.LNX.4.64.0903142153330.23664@hs20-bc2-1.build.redhat.com>
Date: Sun, 15 Mar 2009 12:22:57 +0900
In-Reply-To: <Pine.LNX.4.64.0903142153330.23664@hs20-bc2-1.build.redhat.com>
	(Mikulas Patocka's message of "Sat, 14 Mar 2009 21:54:38 -0400 (EDT)")
Message-ID: <878wn7h3la.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka <mpatocka@redhat.com> writes:

> Note that the same race condition is happening in all the other 
> filesystems. Maybe move that i_alloc_sem up to ->bmap method caller?

It can be. However, I guess locking strategy would be per
filesystems. Because the fs may be using i_alloc_sem in get_block
already.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
