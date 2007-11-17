Return-Path: <linux-kernel-owner+w=401wt.eu-S1760017AbXKQJSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017AbXKQJSB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 04:18:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbXKQJRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 04:17:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbXKQJRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 04:17:47 -0500
Message-ID: <473EB0E4.2090708@redhat.com>
Date: Sat, 17 Nov 2007 01:14:12 -0800
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
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
> Uli doesn't care that much about async syscalls, but I think that from a 
> kernel standpoint, we'd want to use this same indirect call for async 
> scheduling,

Note that I added a flags parameter to sys_indirect in the v3 patch.
This should allow you to add additional functionality like syslets
later.  Currently a zero value is enforced.  In future nonzero values
could also imply that the function takes additional parameters.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFHPrDk2ijCOnn/RHQRAks1AJ43zF42Vy2ru2D8X3W13YlzYpazUQCfci37
wTKr35RIViiwkQWNMMCeMdk=
=Gmld
-----END PGP SIGNATURE-----
