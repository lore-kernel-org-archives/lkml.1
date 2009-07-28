Return-Path: <linux-kernel-owner+w=401wt.eu-S1751773AbZG1Tti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbZG1Tti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbZG1Tti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:49:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34112 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbZG1Tth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:49:37 -0400
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Zachary Amsden <zamsden@redhat.com>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, hch@infradead.org, akpm@linux-foundation.org,
       Paul.Clements@steeleye.com, tytso@mit.edu, miklos <miklos@szeredi.hu>
Subject: Re: [PATCH] Allow userspace block device implementation
From: Andi Kleen <andi@firstfloor.org>
References: <4A6D79F6.3050509@redhat.com> <1248699365.6987.1628.camel@twins>
	<20090727142536.465799aa@lxorguk.ukuu.org.uk>
	<4A6E529B.9030104@kernel.org> <4A6E764E.80805@redhat.com>
	<20090728112734.5a75752d@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907280851360.3186@localhost.localdomain>
	<f73f7ab80907281136k2d7797bat2526d1798aba2f85@mail.gmail.com>
Date: Tue, 28 Jul 2009 21:49:34 +0200
In-Reply-To: <f73f7ab80907281136k2d7797bat2526d1798aba2f85@mail.gmail.com> (Kyle Moffett's message of "Tue, 28 Jul 2009 14:36:31 -0400")
Message-ID: <87d47kh9kh.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett <kyle@moffetthome.net> writes:
>
>   (1) The ability to rearrange, resize, and restructure
> partition-tables on the fly.  The existing "re-read partition tables"
> infrastructure does not safely and reasonably handle changes to the
> partition-table while partitions are mounted. 

It doesn't today (and I really hate it too), but is there a hard reason it
couldn't be fixed to support that properly? 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
