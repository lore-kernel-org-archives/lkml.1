Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbXFCXKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbXFCXKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 19:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbXFCXKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 19:10:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbXFCXKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 19:10:37 -0400
Message-ID: <46634A2A.9060208@redhat.com>
Date: Sun, 03 Jun 2007 16:09:30 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/2] ufd v1 - use unsequential O(1) fdmap
References: <send-serie.davidel@xmailserver.org.24319.1180825146.2> <4663067C.9050002@redhat.com> <Pine.LNX.4.64.0706031127220.13247@alien.or.mcafeemobile.com> <466319DB.80800@redhat.com> <Pine.LNX.4.64.0706031311490.13247@alien.or.mcafeemobile.com> <4663289D.5030109@redhat.com> <Pine.LNX.4.64.0706031601150.13247@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0706031601150.13247@alien.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Davide Libenzi wrote:
> Randomizing the base is not a problem. Should this be always, or flag 
> driven?

I would say all the time.  I don't think it's a problem with
reproducibility in any reasonable code.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGY0oq2ijCOnn/RHQRArmJAJ99Q0dLsPcnQQHjmSpLgv8va/F8/wCgyF06
57LVbqftsMC9x0/CzjWTgkw=
=WXM6
-----END PGP SIGNATURE-----
