Return-Path: <linux-kernel-owner+w=401wt.eu-S1761670AbZCSW13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761670AbZCSW13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 18:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760603AbZCSW1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 18:27:08 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:42881 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761599AbZCSW1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 18:27:07 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] deadlock when swapping to FAT
References: <Pine.LNX.4.64.0903120819010.26206@hs20-bc2-1.build.redhat.com>
	<87zlfqohfn.fsf@devron.myhome.or.jp>
	<Pine.LNX.4.64.0903142153330.23664@hs20-bc2-1.build.redhat.com>
	<878wn7h3la.fsf@devron.myhome.or.jp>
	<Pine.LNX.4.64.0903170815110.26754@hs20-bc2-1.build.redhat.com>
	<87prgg6sj2.fsf@devron.myhome.or.jp>
	<Pine.LNX.4.64.0903191052180.14051@hs20-bc2-1.build.redhat.com>
Date: Fri, 20 Mar 2009 07:27:00 +0900
In-Reply-To: <Pine.LNX.4.64.0903191052180.14051@hs20-bc2-1.build.redhat.com>
	(Mikulas Patocka's message of "Thu, 19 Mar 2009 15:34:00 -0400 (EDT)")
Message-ID: <8763i5xi6j.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka <mpatocka@redhat.com> writes:

> It should prevent truncation under bmap. It is used by direct-io code to 
> protect the file from being truncated while there's direct-io being 
> processed on it.

I know, FAT is ok, of course, and the simple fs would also be ok.
However, it's not enough for all filesystems, in theory.

> But some filesystems do their own direct-io locking (for example XFS). So 
> I think it would be best to place the lock to generic_block_bmap, so that 
> filesystem that doesn't want the lock can easily avoid it.
>
> You can submit this patch after 2.6.29 is released.

I don't have objection to it. Please submit it yourself.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
