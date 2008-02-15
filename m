Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbYBORQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbYBORQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756719AbYBORPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:15:51 -0500
Received: from mail.suse.de ([195.135.220.2]:42888 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbYBORPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:15:50 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] checkpatch.pl: revert wrong --file message
Date: Fri, 15 Feb 2008 18:15:43 +0100
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andy Whitcroft <andyw@uk.ibm.com>
References: <20080215165244.GA28358@elte.hu>
In-Reply-To: <20080215165244.GA28358@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802151815.44050.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> In the past few months we frequently mentioned checkpatch.pl --file to 
> arch/x86 newbies and it's been a great source of cleanup patches and it 
> has become an integral part of our workflow. Newbies should start with 
> small baby steps, with trivial patches, they should learn to write clean 
> code, they should learn how to interact with other Linux developers and 
> then they'll evolve over time towards larger changes.

I found this doesn't work unfortunately. 

I actively worked with a few people who sent continuous streams of formatting
only checkpatch.pl patches in the last months trying to get them to graduate to 
more complex patches and found they always had to little C knowledge to actively 
contribute something actually useful to the kernel.

At the end I usually had to give them the honest advice "You need to learn
more C first, but I'm afraid the kernel is not the best place to learn C
because it is too unforgiving".

I'm all for actively recruiting new developers (and I think I did my fair 
share on that front), but trying to turn absolute C newbies into
kernel hackers short term just doesn't work. 

On the other hand I found that people who already know enough C and start 
hacking code directly do not really need the "white space only" stage.
They just start hacking code directly. They usually need some education
on how to properly send patches, but that can be always done with
real bug fixes or changes they did.

Out of that experience came the checkpatch.pl message.

-Andi

