Return-Path: <linux-kernel-owner+w=401wt.eu-S933365AbXG0Iar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbXG0Iar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 04:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757423AbXG0Iai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 04:30:38 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:59290 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250AbXG0Iah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 04:30:37 -0400
Message-ID: <46A9ACB2.9030302@gmail.com>
Date: Fri, 27 Jul 2007 10:28:34 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Jesper Juhl <jesper.juhl@gmail.com>, Andika Triwidada <andika@gmail.com>,
       Robert Deaton <false.hopes@gmail.com>, linux-kernel@vger.kernel.org,
       ck list <ck@vds.kolivas.org>, linux-mm@kvack.org
Subject: Re: updatedb
References: <367a23780707250830i20a04a60n690e8da5630d39a9@mail.gmail.com>	 <46A773EA.5030103@gmail.com>	 <a491f91d0707251015x75404d9fld7b3382f69112028@mail.gmail.com>	 <46A81C39.4050009@gmail.com>	 <7e0bae390707252323k2552c701x5673c55ff2cf119e@mail.gmail.com>	 <9a8748490707261746p638e4a98p3cdb7d9912af068a@mail.gmail.com>	 <46A98A14.3040300@gmail.com> <1185522844.6295.64.camel@Homer.simpson.net>
In-Reply-To: <1185522844.6295.64.camel@Homer.simpson.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2007 09:54 AM, Mike Galbraith wrote:

> On Fri, 2007-07-27 at 08:00 +0200, Rene Herman wrote:
> 
>> The remaining issue of updatedb unnecessarily blowing away VFS caches is 
>> being discussed (*) in a few thread-branches still running.
> 
> If you solve that, the swap thing dies too, they're one and the same
> problem.

I still wonder what the "the swap thing" is though. People just kept saying 
that swap-prefetch helped which would seem to indicate their problem didnt 
have anything to do with updatedb.

Also, I know shit about the VFS so this may well be not very educated but to 
me something like FADV_NOREUSE on a dirfd sounds like a much more promising 
approach than the convoluted userspace schemes being discussed, if only 
because it'll actually be implemented/used.

Rene.

