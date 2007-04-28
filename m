Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbXD1Uqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbXD1Uqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbXD1Uqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:46:30 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:34629 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbXD1Uq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:46:29 -0400
Date: Sat, 28 Apr 2007 22:46:27 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
In-Reply-To: <20070427013350.d0d7ac38.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704282242280.16099@artax.karlin.mff.cuni.cz>
References: <1177660767.6567.41.camel@Homer.simpson.net>
 <20070427013350.d0d7ac38.akpm@linux-foundation.org>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> hm, fsync.
>
> Aside: why the heck do applications think that their data is so important
> that they need to fsync it all the time.  I used to run a kernel on my
> laptop which had "return 0;" at the top of fsync() and fdatasync().  Most
> pleasurable.
>
> But wedging for 20 minutes is probably excessive punishment.

I most wonder, why vim fsyncs its swapfile regularly (blocking typing 
during that) and doesn't fsync the resulting file on :w  :-/

Mikulas
