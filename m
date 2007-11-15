Return-Path: <linux-kernel-owner+w=401wt.eu-S934123AbXKOXbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123AbXKOXbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 18:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765450AbXKOXbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 18:31:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764979AbXKOXbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 18:31:11 -0500
Message-ID: <473CD6A3.2070306@redhat.com>
Date: Thu, 15 Nov 2007 15:30:43 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/4] sys_indirect system call
References: <200711151641.lAFGfM8R024330@devserv.devel.redhat.com> <473CC604.5050804@oracle.com> <alpine.LFD.0.9999.0711151431220.4260@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0711151431220.4260@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> Uli doesn't care that much about async syscalls,

At the moment I just care a lot more about getting the API straightened
out.  An asynchronous incomplete/unsafe API is still an
incomplete/unsafe API.

BTW, I've botched the x86-on-x86_64 support.  I have a patch but need to
patch it before I'll submit v3 of the patch set.  If you want to work on
the patch and get syslet support going, let me know, I'll send the
latest version.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHPNaj2ijCOnn/RHQRAqNCAJ9eO8px9NTgXBuAR1ueVpQaY3gdnwCgke3g
hqtO6djA2fNZTQS2qDq8w2A=
=AInz
-----END PGP SIGNATURE-----
