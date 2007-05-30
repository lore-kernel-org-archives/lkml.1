Return-Path: <linux-kernel-owner+w=401wt.eu-S1759669AbXE3VjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669AbXE3VjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbXE3Vi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:38:59 -0400
Received: from gw.goop.org ([64.81.55.164]:39839 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860AbXE3Vi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:38:58 -0400
Message-ID: <465DEEEE.8040702@goop.org>
Date: Wed, 30 May 2007 14:38:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com> <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org> <465DE992.6070803@redhat.com>
In-Reply-To: <465DE992.6070803@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> I don't like special cases.  For me things better come in quantities 0,
> 1, and unlimited (well, reasonable high limit).  Otherwise, who gets to
> use that special namespace?  The C library is not the only body of code
> which would want to use descriptors.

Valgrind could certainly make use of it.  It currently reserves a set of
fds "high enough", and tries hard to hide them from apps, but
/proc/self/fd makes it intractable in general (there was only so much
simulation I was willing to do in Valgrind).

    J
