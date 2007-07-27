Return-Path: <linux-kernel-owner+w=401wt.eu-S937317AbXG0MbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937317AbXG0MbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 08:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934806AbXG0Mav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 08:30:51 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:42180 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934525AbXG0Mau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 08:30:50 -0400
Message-ID: <46A9E4FC.80403@gmail.com>
Date: Fri, 27 Jul 2007 14:28:44 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Jesper Juhl <jesper.juhl@gmail.com>, Andika Triwidada <andika@gmail.com>,
       Robert Deaton <false.hopes@gmail.com>, linux-kernel@vger.kernel.org,
       ck list <ck@vds.kolivas.org>, linux-mm@kvack.org, B.Steinbrink@gmx.de,
       Andrew Morton <akpm@osdl.org>
Subject: Re: updatedb
References: <367a23780707250830i20a04a60n690e8da5630d39a9@mail.gmail.com>	 <46A773EA.5030103@gmail.com>	 <a491f91d0707251015x75404d9fld7b3382f69112028@mail.gmail.com>	 <46A81C39.4050009@gmail.com>	 <7e0bae390707252323k2552c701x5673c55ff2cf119e@mail.gmail.com>	 <9a8748490707261746p638e4a98p3cdb7d9912af068a@mail.gmail.com>	 <46A98A14.3040300@gmail.com> <1185522844.6295.64.camel@Homer.simpson.net>	 <46A9ACB2.9030302@gmail.com> <1185528368.7851.44.camel@Homer.simpson.net>	 <46A9D26E.9010703@gmail.com> <1185536880.8978.34.camel@Homer.simpson.net>
In-Reply-To: <1185536880.8978.34.camel@Homer.simpson.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2007 01:48 PM, Mike Galbraith wrote:

> physical ram.  If it really does use only free ram, that indeed sounds
> pretty pointless.

Con's quote from a bit below that seems to confirm the "only free" nicely.

> I believe the users who say their apps really do get paged back in
> though, so suspect that's not the case.

Stopping the bush-circumference beating, I do not. -ck (and gentoo) have 
this massive Calimero thing going among their users where people are much 
less interested in technology than in how the nasty big kernel meanies are 
keeping them down (*).

Nick Piggin has been unable to get anyone to substantiate anything it seems 
and even this thread alone (and I privately) received a few "oh, heh, sorry, 
I don't actually have a friggin' clue what I'm talking about" responses. As 
such, I believe it's fairly safe to dump the updatedb thing in the garbage 
as not a practical problem.

Leaves the issue of for example a midnight backup run that could very well 
itself grow large enough to leave massive amounts of free memory at exit 
which swap-prefetch _would_ help with. I haven't much opinion on how 
important such situations are but trying to do something to help those seems 
sensible in itself.

Rene.

(*) which isn't to say that you guys aren't in fact nasty big kernel meanies 
ofcourse.

