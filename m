Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbXKUUrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbXKUUrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 15:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbXKUUq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 15:46:56 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:38390 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbXKUUq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 15:46:56 -0500
Message-ID: <47449932.3090801@oracle.com>
Date: Wed, 21 Nov 2007 12:46:42 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
CC: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]loop cleanup in fs/namespace.c - repost
References: <47447184.6040805@gmail.com> <474481B9.9000603@oracle.com> <47448D0A.1040405@gmail.com>
In-Reply-To: <47448D0A.1040405@gmail.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> This doesn't look fine.  Did you test this?
> 
> Oops, my fault. Of course, I tested the patch, but kernel modules are
> disabled in my test setup, so I missed the error.

:)

> Enclosed to this message is a new patch, which replaces the goto-loop by
> the while-based one, but leaves the EXPORT_SYMBOL macro intact.

It certainly looks OK to me now, for whatever that's worth.

You probably want to wait 'till the next merge window to get it in,
though.  It's just a cleanup and so shouldn't go in this late in the -rc
line.

Maybe Andrew will be willing to queue it until that time in -mm.

- z
