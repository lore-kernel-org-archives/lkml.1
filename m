Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbZEZAgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbZEZAgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 20:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbZEZAgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 20:36:37 -0400
Received: from mail.lang.hm ([64.81.33.126]:41834 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbZEZAgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 20:36:37 -0400
Date: Mon, 25 May 2009 17:35:51 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Oliver Neukum <oliver@neukum.org>
cc: nigel@tuxonice.net, Pavel Machek <pavel@ucw.cz>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
In-Reply-To: <200905260029.25847.oliver@neukum.org>
Message-ID: <alpine.DEB.1.10.0905251732310.18053@asgard>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <20090525123228.GA13446@elf.ucw.cz> <1243287557.16743.114.camel@nigel-laptop> <200905260029.25847.oliver@neukum.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009, Oliver Neukum wrote:

> Am Montag, 25. Mai 2009 23:39:17 schrieb Nigel Cunningham:
>>> If there's not enough swap available, swsusp should freeze, realize
>>> there's no swap, unfreeze and continue. I do not see reliability
>>> problem there.
>>
>> If there's not enough storage available (I'm also thinking of the file
>> allocator Oliver wants), freeing some memory may get you in a position
>
> No, I do want a dedicated partition. Going to a filesystem is just hiding
> the problem. Filesystems can return -ENOSPC.
> I also want my sytem to reliably hibernate if the filesystem to hold
> the image happens to be remounted ro or to be undergoing a filesystem
> check.
>
> For full reliability you simply need a reservation. In addition that's
> the fastest solution, too. A simple linear write to an unfragmented
> area.
> The typical system today has three orders of magnitude more disk
> than ram. Do you really have a sytem you want to hibernate that has
> less than 2two orders of magnitude more disk than ram?

I actually have a couple of systems that have 128G of ram and 144G of 
disk. and it can't take 3.5" drives (and I don't know if it's SAS 
backplane can drive SATA drives, if so it can't take many of them) so the 
'dives are cheap' answer may not work.

now, the question of if it makes sense to try and hibernate this system is 
a very valid one.

David Lang
