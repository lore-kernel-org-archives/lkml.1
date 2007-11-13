Return-Path: <linux-kernel-owner+w=401wt.eu-S1761402AbXKMSoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761402AbXKMSoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761224AbXKMSn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:43:58 -0500
Received: from rtr.ca ([76.10.145.34]:2526 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758861AbXKMSn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:43:56 -0500
Message-ID: <4739F069.6050102@rtr.ca>
Date: Tue, 13 Nov 2007 13:43:53 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ingo Molnar <mingo@elte.hu>, alsa-devel@alsa-project.org,
       netdev@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, protasnb@gmail.com,
       linux-ide@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [BUG] New Kernel Bugs
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org> <20071113.033946.114918709.davem@davemloft.net> <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca> <20071113164650.GA28493@elte.hu> <4739E3D0.10201@rtr.ca> <20071113183925.GF17785@parisc-linux.org>
In-Reply-To: <20071113183925.GF17785@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Nov 13, 2007 at 12:50:08PM -0500, Mark Lord wrote:
>> It's a 540MByte download over a slow link for everyone else.
> 
> Where do you get this number from?
> $ du -sh .git/objects/pack/
> 249M    .git/objects/pack/
> $ du -sh .git/objects/
> 253M    .git/objects/
> 
> ie about half what you claim.
..

No, it's from earlier in this very thread:

Adrian Bunk wrote:
> The small instruction below is enough for everyone who is able to 
> build his own kernel to do a git bisect.
..
> <--  snip  -->
> 
> 
> # install git
> 
> # clone Linus' tree:
> git clone \ 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
..

mkdir t
cd t
git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
(wait half an hour)
/usr/bin/du -s linux-2.6
522732  linux-2.6



