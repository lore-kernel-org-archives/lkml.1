Return-Path: <linux-kernel-owner+w=401wt.eu-S1751904AbXE3Hdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbXE3Hdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 03:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbXE3Hdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 03:33:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbXE3Hda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 03:33:30 -0400
Message-ID: <465D286E.2080807@redhat.com>
Date: Wed, 30 May 2007 00:31:58 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeff Garzik <jeff@garzik.org>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu>
In-Reply-To: <20070530072055.GA3077@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ingo Molnar wrote:
> 3 months ago i verified the published kevent vs. epoll benchmark and 
> found that benchmark to be fatally flawed. When i redid it properly 
> kevent showed no significant advantage over epoll.

I'm not going to judge your tests but saying there are no significant
advantages is too one-sided.  There is one huge advantage: the
interface.  A memory-based interface is simply the best form.  File
descriptors are a resource the runtime cannot transparently consume.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGXShu2ijCOnn/RHQRAi5ZAJ920rRneulUMjTETu6XoiOaOi7SLgCfbmO+
UDM1CLqbaEZREAMnuOWRzuY=
=CERV
-----END PGP SIGNATURE-----
