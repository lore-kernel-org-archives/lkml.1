Return-Path: <linux-kernel-owner+w=401wt.eu-S1758832AbYGPPRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbYGPPRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672AbYGPPQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:16:53 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50368 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbYGPPQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:16:53 -0400
Date: Wed, 16 Jul 2008 17:16:51 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Adrian Bunk <bunk@kernel.org>, jkacur <jkacur@gmail.com>,
       akpm@linux-foundation.org, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Make the git URL match usage
In-Reply-To: <20080716134144.GA28848@sirena.org.uk>
Message-ID: <alpine.LNX.1.10.0807161714410.32031@fbirervta.pbzchgretzou.qr>
References: <200807161500.08500.jkacur@gmail.com> <20080716133108.GC25557@cs181140183.pp.htv.fi> <20080716134144.GA28848@sirena.org.uk>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-07-16 15:41, Mark Brown wrote:
>
>> > T:      git://opensource.wolfsonmicro.com/linux-2.6-asoc
>> > T:      git://opensource.wolfsonmicro.com/linux-2.6-touch
>> >...
>
>> With the default git-daemon configuration it doesn't matter whether or 
>> not you specify a .git postfix.
>
>For those two HTTP access currently requires that the .git be omitted.
>I could change that easily enough but TBH I prefer giving the link with
>the directory name that a clone would create anyway.

I also don't see the usefulness of having .git postfixes (it does have a
*point* though, it just does not convince me) in hives that are
obviously bare. Like, if you go into /srv/git, you would expect bare
repos, as is the case when doing a fetch from git:// or
ssh://server/srv/git/...  For storing bare git repos in ~, a .git suffix
can be helpful.
