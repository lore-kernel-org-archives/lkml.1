Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbXKNOb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbXKNOb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbXKNObO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:31:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38797 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197AbXKNObN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:31:13 -0500
Date: Wed, 14 Nov 2007 15:30:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Lord <liml@rtr.ca>
Cc: Matthew Wilcox <matthew@wil.cx>, alsa-devel@alsa-project.org,
       netdev@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, protasnb@gmail.com,
       linux-ide@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071114143040.GA31025@elte.hu>
References: <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca> <20071113164650.GA28493@elte.hu> <4739E3D0.10201@rtr.ca> <20071113183925.GF17785@parisc-linux.org> <4739F069.6050102@rtr.ca> <20071113184902.GG17785@parisc-linux.org> <4739F2DD.5050802@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4739F2DD.5050802@rtr.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark Lord <liml@rtr.ca> wrote:

>> You're assuming that everything in linux-2.6 was downloaded; that's 
>> not true.  Everything in linux-2.6/.git was downloaded; but then you 
>> do a checkout which happens to approximately double the size of the 
>> linux-2.6 directory.
> ..
>
> Ah, I wondered why it took only half an hour to download.

and you can get even lower than the 260MB by downloading a shallow clone 
of v2.6.23 and then populating the git tree from tht point on. (see the 
--depth parameter of git-clone) [because most of the time you want to 
bisect back to the last stable release, not back to 2 years of git 
history.]

	Ingo

