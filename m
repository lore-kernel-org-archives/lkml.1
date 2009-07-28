Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbZG1BUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbZG1BUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 21:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZG1BUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 21:20:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:51445 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbZG1BUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 21:20:12 -0400
Message-ID: <4A6E529B.9030104@kernel.org>
Date: Tue, 28 Jul 2009 10:21:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Peter Zijlstra <peterz@infradead.org>, Zachary Amsden <zamsden@redhat.com>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       axboe@kernel.dk, hch@infradead.org, akpm@linux-foundation.org,
       Paul.Clements@steeleye.com, tytso@mit.edu, miklos <miklos@szeredi.hu>
Subject: Re: [PATCH] Allow userspace block device implementation
References: <4A6D79F6.3050509@redhat.com>	<1248699365.6987.1628.camel@twins> <20090727142536.465799aa@lxorguk.ukuu.org.uk>
In-Reply-To: <20090727142536.465799aa@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 28 Jul 2009 01:19:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Alan Cox wrote:
>> Somehow this made me think of FUSE/CUSE... should this be named aBUSE?
>> Oh wait it is :-), what I'm after is I guess is, can we share some of
>> the FUSE/CUSE code?
> 
> It reminds me of the existing and perfectly functional network block
> device (nbd) we already have and which has also been present for years.

Yeah, I think this is the biggest hurdle against (a)BUSE.  Is it
sufficiently different from nbd?  nbd-like functionality can be
implemented something via FUSE and maybe it can be said that things
are cleaner that way but nbd has been in the kernel for a long time
now and it's definitely much easier to do swap over it when the whole
thing is in kernel.

Thanks.

-- 
tejun
