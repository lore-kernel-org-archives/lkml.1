Return-Path: <linux-kernel-owner+w=401wt.eu-S935416AbXG0GDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935416AbXG0GDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 02:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbXG0GC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 02:02:56 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:56875 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbXG0GCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 02:02:55 -0400
Message-ID: <46A98A14.3040300@gmail.com>
Date: Fri, 27 Jul 2007 08:00:52 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Andika Triwidada <andika@gmail.com>, Robert Deaton <false.hopes@gmail.com>,
       linux-kernel@vger.kernel.org, ck list <ck@vds.kolivas.org>,
       linux-mm@kvack.org
Subject: Re: updatedb
References: <367a23780707250830i20a04a60n690e8da5630d39a9@mail.gmail.com>	 <46A773EA.5030103@gmail.com>	 <a491f91d0707251015x75404d9fld7b3382f69112028@mail.gmail.com>	 <46A81C39.4050009@gmail.com>	 <7e0bae390707252323k2552c701x5673c55ff2cf119e@mail.gmail.com> <9a8748490707261746p638e4a98p3cdb7d9912af068a@mail.gmail.com>
In-Reply-To: <9a8748490707261746p638e4a98p3cdb7d9912af068a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2007 02:46 AM, Jesper Juhl wrote:

> On 26/07/07, Andika Triwidada <andika@gmail.com> wrote:

>> Might be insignificant, but updatedb calls find (~2M) and sort (~26M). 
>> Definitely not RAM intensive though (RAM is 1GB).
> 
> That doesn't match my box at all :

[ ... ]

> This is a Slackware Linux 12.0 system.

Yes, already identified that there are more updatedb's around. We are using 
"Secure Locate" and others simply the locate from the GNU findutils. Either 
version does not itself use significant memory though and seems irrelevant 
to the orginal swap-prefetch issue -- if updatedb filled memory with inodes 
and dentries the memory is no longer free and swap-prefetch can't prefetch 
anything.

The remaining issue of updatedb unnecessarily blowing away VFS caches is 
being discussed (*) in a few thread-branches still running.

Rene.

(*) I so much wanted to say "buried".

