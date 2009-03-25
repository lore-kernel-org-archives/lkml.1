Return-Path: <linux-kernel-owner+w=401wt.eu-S1757154AbZCYWDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbZCYWDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 18:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbZCYWCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 18:02:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59369 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754997AbZCYWCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 18:02:50 -0400
Date: Wed, 25 Mar 2009 22:01:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] issue storage device flush via sync_blockdev() (was Re:
 Linux 2.6.29)
Message-ID: <20090325220108.582a1f88@lxorguk.ukuu.org.uk>
In-Reply-To: <20090325212923.GA5620@havoc.gtf.org>
References: <20090324132032.GK5814@mit.edu>
	<alpine.LFD.2.00.0903241053200.3032@localhost.localdomain>
	<20090324184549.GE32307@mit.edu>
	<alpine.LFD.2.00.0903241218130.3032@localhost.localdomain>
	<49C93AB0.6070300@garzik.org>
	<20090325093913.GJ27476@kernel.dk>
	<49CA86BD.6060205@garzik.org>
	<20090325194341.GB27476@kernel.dk>
	<49CA9346.6040108@garzik.org>
	<alpine.LFD.2.00.0903251337410.3032@localhost.localdomain>
	<20090325212923.GA5620@havoc.gtf.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a simple step that would cover a lot of cases...  sync(2)
> calls sync_blockdev(), and many filesystems do as well via the generic
> filesystem helper file_fsync (fs/sync.c).

file_fsync probably needs to pass down more information so you can make
this a mount option. It's going to depend on the application whether the
flush is good bad or indifferent.
