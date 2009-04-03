Return-Path: <linux-kernel-owner+w=401wt.eu-S933579AbZDCPH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579AbZDCPH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbZDCPHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:07:50 -0400
Received: from rtr.ca ([76.10.145.34]:40727 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbZDCPHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:07:49 -0400
Message-ID: <49D62643.2080809@rtr.ca>
Date: Fri, 03 Apr 2009 11:07:47 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Janne Grunau <j@jannau.net>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402110532.GA5132@aniel>
In-Reply-To: <20090402110532.GA5132@aniel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Janne Grunau wrote:
>..
> MythTV calls fsync every few seconds on ongoing recordings to prevent
> stalls due to large cache writebacks on ext3.
>
> Janne
> (MythTV developer)
..

Oooh.. a myth dev!

With the HVR-1600 card, myth calls fsync() *ten* times a second
while recording analog TV (digital is fine).

Any chance you could track down and fix that ?

It might be the same thing that's biting Lennart's system
with his PVR-500 card.

Cheers
