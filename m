Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbYBPLEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbYBPLEl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 06:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbYBPLEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 06:04:32 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:33036 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbYBPLEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 06:04:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=KSLIttOTBLaxqkvBfxTSQXL0hxa86yG22XMv3/s5BGREOvnOf0CIDgKSOMIAc0cWq8vDxUfCeLgRb59MDqvz4hXCMuFBPb889eLDBub4gY7oqIzGhR4EhLhHAH60tBUVTIBPk+v6xF4YURPrIB5e1cb7oaCGB+SqQPZ9FxKdogU=
Date: Sat, 16 Feb 2008 14:04:05 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andy Whitcroft <andyw@uk.ibm.com>
Subject: Re: [patch] checkpatch.pl: revert wrong --file message
Message-ID: <20080216110405.GB6753@cvg>
References: <20080215165244.GA28358@elte.hu> <200802151815.44050.ak@suse.de> <alpine.LFD.1.00.0802161026550.7583@apollo.tec.linutronix.de> <84144f020802160227u59c9959emb905808cc7141f2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020802160227u59c9959emb905808cc7141f2b@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pekka Enberg - Sat, Feb 16, 2008 at 12:27:33PM +0200]
| Hi,
| 
| On Feb 16, 2008 12:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
| > People, who do cleanups - I'm not talking about running lindent here -
| > read through the code while they fix it up.
| >
| > Actually they find bugs that way or at least come up with useful
| > questions about code which is not obvious in the first place.
| >
| > Discouraging such cleanups with a pretty offensive warning is
| > counterproductive.
| 
| Well, it's not just about cleanup patches submitted by "newbies". I
| use checkpatch for development too and the warning is real PITA for
| that.
| 

As the one who sent such a cleanup sometime ago I think I've rights to
say my POV ;)

Benefits
--------

I think all developers would agree with me that to have a clean code is
quite good. Even removing absolutely useless 'spaces' is good. Ingo
wrote a lot about such a benefit month ago - and I think most (or even
all) of developers agree with him. Actually I've
(show-trailing-whitespace t) in my emacs settings - so every useless
space char makes me nerve - of course I could turn this setting off
and be happy but...

Dark side of space-removing-patches
-----------------------------------

The only problem could be - such a cleanup would break patches
*already* in maintainer queue. And from that side I really understand
Andi's complains about such patches.

		- Cyrill -
