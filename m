Return-Path: <linux-kernel-owner+w=401wt.eu-S1161862AbXD1Q5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161862AbXD1Q5S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 12:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161863AbXD1Q5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 12:57:18 -0400
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:48742 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161862AbXD1Q5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 12:57:17 -0400
Date: Sat, 28 Apr 2007 18:56:08 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthias Andree <matthias.andree@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
Message-ID: <20070428185608.6b7bbf3f@localhost>
In-Reply-To: <alpine.LFD.0.98.0704280928530.9964@woody.linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	<alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
	<20070427113117.98c4f88b.akpm@linux-foundation.org>
	<20070428085148.GC31196@merlin.emma.line.org>
	<alpine.LFD.0.98.0704280928530.9964@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.6.1 (GTK+ 2.10.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 09:30:06 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> There are worse examples. Try connecting some flash disk over USB-1, and 
> untar to it. Ugh.
> 
> I'd love to have some per-device dirty limit, but it's harder than it 
> should be.

this one should help:

Patch: per device dirty throttling
http://lwn.net/Articles/226709/

-- 
	Paolo Ornati
	Linux 2.6.21-cfs-v7-g13fe02de on x86_64
