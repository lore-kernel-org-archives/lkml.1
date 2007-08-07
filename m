Return-Path: <linux-kernel-owner+w=401wt.eu-S934425AbXHGO4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934425AbXHGO4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758927AbXHGO4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:56:33 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:53716 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300AbXHGO4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:56:33 -0400
Message-ID: <46B8876C.70604@gmail.com>
Date: Tue, 07 Aug 2007 16:53:32 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
References: <1186248703.3439.20.camel@localhost.localdomain>	 <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org> <1186458941.6637.44.camel@localhost.localdomain>
In-Reply-To: <1186458941.6637.44.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2007 05:55 AM, James Bottomley wrote:

> I really, *really* think we need a pre-release tree that consists of all 
> the upstream targetted features (i.e. all of the for the next merge 
> window git trees) and nothing else.  -mm doesn't really satisfy this, 
> because it has so much other stuff that the people I need to get testing 
> this don't trust it.

I much agree with this. I used to run -mm at least somewhat frequently if it 
included stuff I was interested in (random features, or for example latest 
ALSA) but gave that up after I had it break on something unrelated and (to 
me) uninteresting a few times too many. There's so much in there that before 
you know it you end up spending time not on that which you wanted to spend 
time on but on something completely unrelated which given a fixed amount of 
available total time (and level/spread of knowledge/interest) gets to be a 
problem.

For latest ALSA, I now sometimes look at the ALSA repositories directly but 
otherwise it seems I'm not testing much of anything before late -rc's.

Not everything going to Linus gets there by way of -mm, but perhaps it could 
help if Andrew split off -merge from -mm, where -merge contained only stuff 
(from -mm) expected to go upstream in the next merge window.

Not sure if this is proposing that other people do more work -- wouldn't 
want do to anything of the sort...

Rene.
