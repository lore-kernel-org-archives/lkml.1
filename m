Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbXKNOtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbXKNOtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbXKNOtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:49:39 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:60431 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752585AbXKNOti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:49:38 -0500
Message-ID: <473B0AFB.2080400@lwfinger.net>
Date: Wed, 14 Nov 2007 08:49:31 -0600
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mark Lord <liml@rtr.ca>, alsa-devel@alsa-project.org,
       Matthew Wilcox <matthew@wil.cx>, netdev@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       protasnb@gmail.com, linux-ide@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [BUG] New Kernel Bugs
References: <20071113.035824.40509981.davem@davemloft.net>	<20071113041259.79c9a8c5.akpm@linux-foundation.org>	<20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca>	<20071113164650.GA28493@elte.hu> <4739E3D0.10201@rtr.ca>	<20071113183925.GF17785@parisc-linux.org> <4739F069.6050102@rtr.ca>	<20071113184902.GG17785@parisc-linux.org> <4739F2DD.5050802@rtr.ca> <20071114143040.GA31025@elte.hu>
In-Reply-To: <20071114143040.GA31025@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mark Lord <liml@rtr.ca> wrote:
> 
>>> You're assuming that everything in linux-2.6 was downloaded; that's 
>>> not true.  Everything in linux-2.6/.git was downloaded; but then you 
>>> do a checkout which happens to approximately double the size of the 
>>> linux-2.6 directory.
>> ..
>>
>> Ah, I wondered why it took only half an hour to download.
> 
> and you can get even lower than the 260MB by downloading a shallow clone 
> of v2.6.23 and then populating the git tree from tht point on. (see the 
> --depth parameter of git-clone) [because most of the time you want to 
> bisect back to the last stable release, not back to 2 years of git 
> history.]

When creating additional git trees (Linville's wireless-2.6 tree, for example) for driver
development, you can save a lot of download bandwidth by using the --reference parameter of git-clone.

Larry
