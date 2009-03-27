Return-Path: <linux-kernel-owner+w=401wt.eu-S1759667AbZC0TOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbZC0TOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 15:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbZC0TN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 15:13:56 -0400
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:37727 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753430AbZC0TNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 15:13:55 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-12.arcor-online.net 1648E1B3AE1
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH 1/2] Add a strictatime mount option
To: Matthew Garrett <mjg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Reply-To: 7eggert@gmx.de
Date: Fri, 27 Mar 2009 20:13:44 +0100
References: <cjJiR-3rY-9@gated-at.bofh.it> <cjKHX-5MF-17@gated-at.bofh.it> <cjLb2-6no-13@gated-at.bofh.it> <cjTLl-3ln-15@gated-at.bofh.it> <cjW6r-72f-21@gated-at.bofh.it> <cjYrG-2u0-23@gated-at.bofh.it> <cjZ4h-3jp-19@gated-at.bofh.it> <ck0D8-5Ua-11@gated-at.bofh.it> <ck1fN-6Yp-25@gated-at.bofh.it> <ck1zb-7o2-29@gated-at.bofh.it> <ck22i-7Zy-25@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LnHUu-0001hc-V4@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg@redhat.com> wrote:

> Add support for explicitly requesting full atime updates. This makes it
> possible for kernels to default to relatime but still allow userspace to
> override it.

Maybe the *atime should be consolidated to atime=foo.

