Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbZJHVOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbZJHVOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 17:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbZJHVOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 17:14:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754688AbZJHVOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 17:14:38 -0400
Date: Thu, 8 Oct 2009 14:13:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>
cc: James Bottomley <James.Bottomley@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
In-Reply-To: <20091008210737.GD29181@mit.edu>
Message-ID: <alpine.LFD.2.01.0910081410400.3432@localhost.localdomain>
References: <1254844007.4383.85.camel@mulgrave.site> <alpine.LFD.2.01.0910060851590.3432@localhost.localdomain> <1254862442.4383.183.camel@mulgrave.site> <1255012399.4187.24.camel@mulgrave.site> <alpine.LFD.2.01.0910080736490.3432@localhost.localdomain>
 <alpine.LFD.2.01.0910080742230.3432@localhost.localdomain> <1255031298.4187.260.camel@mulgrave.site> <alpine.LFD.2.01.0910081252090.3432@localhost.localdomain> <alpine.LFD.2.01.0910081255510.3432@localhost.localdomain> <20091008210737.GD29181@mit.edu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Oct 2009, Theodore Tso wrote:
> 
> So would it be acceptable to merge the 50 kloc of crap _during_ the
> merge window?

Yes. I actually looked at the driver (since I had pulled it - I've 
unpulled it but am still mulling it over), and while I think it looked 
huge and overly complex, it by no means gave me the kinds of vibes I get 
from some "obviously-ported-from-windows-with-no-clue" drivers.

So at least from my quick look I didn't get the feeling that the driver 
was "evil". For me, it's a timing issue.  I hate getting big pull requests 
after -rc1 is out, and I really don't like the feeling that people are 
just ignoring the merge window.

That said, if somebody wants to look more closely at the driver, and then 
wants to convince people that it should have gone through "staging", feel 
free. But that's not what I've personally been arguing about.

			Linus
