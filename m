Return-Path: <linux-kernel-owner+w=401wt.eu-S1764271AbXGKVfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764271AbXGKVfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760758AbXGKVe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:34:56 -0400
Received: from thunk.org ([69.25.196.29]:41152 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435AbXGKVev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:34:51 -0400
Date: Wed, 11 Jul 2007 17:32:34 -0400
From: Theodore Tso <tytso@mit.edu>
To: Rob Landley <rob@landley.net>
Cc: leoli@freescale.com, Gerrit Huizenga <gh@us.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, tim.bird@am.sony.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, joe@perches.com,
       auke-jan.h.kok@intel.com, hansendc@us.ibm.com, davem@davemloft.net,
       Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, linux-doc@vger.kernel.org
Subject: Re: Documentation of kernel messages (Summary)
Message-ID: <20070711213234.GE19456@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Rob Landley <rob@landley.net>, leoli@freescale.com,
	Gerrit Huizenga <gh@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
	"Kunai, Takashi" <kunai@linux-foundation.jp>,
	holzheu@linux.vnet.ibm.com,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	lf_kernel_messages@linux-foundation.org, mtk-manpages@gmx.net,
	jack@suse.cz, randy.dunlap@oracle.com, gregkh@suse.de, pavel@ucw.cz,
	tim.bird@am.sony.com, arjan@infradead.org, sam@ravnborg.org,
	jengelh@computergmbh.de, joe@perches.com, auke-jan.h.kok@intel.com,
	hansendc@us.ibm.com, davem@davemloft.net, Valdis.Kletnieks@vt.edu,
	kenistoj@us.ibm.com, schwidefsky@de.ibm.com,
	heiko.carstens@de.ibm.com, linux-doc@vger.kernel.org
References: <E1I7wsz-0007oJ-DE@w-gerrit.beaverton.ibm.com> <200707101212.38981.rob@landley.net> <1184163990.23373.46.camel@Gundam> <200707111413.03513.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707111413.03513.rob@landley.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 02:13:02PM -0400, Rob Landley wrote:
> > IMHO, having contribution merged into the kernel has the MAGIC to
> > attract people to work for recognition.  When more and more people
> > volunteer to work on it, the documentation will be up to date magically.
> 
> Obvious counter-arguments include the floppy driver, the floppy tape driver, 
> the tty layer, and most of the existing english Documentation directory...
> 
> I'll happily stay out of the way of people who actually want to merge 
> translations of documentation into the kernel.  I reserve the right to say "I 
> told you so" in about five years.

One thing that would be a VERY good idea is to make sure that each
translated document is tagged with when it was last translated, and
against which kernel version (using either a GIT commit id or a
2.6.x.y revision, I don't care), and who is responsible for keeping
that particular document translated.  That way, it becomes a lot
easier to recognize when something is stale, and if has gotten stale,
we can just delete it.

If someone keeping some files translated into Klingon up to date for 3
months, and then disappears, we can just delete it, and it's no big
deal.  You can even say "I told you so" when you submit the patch to
delete the stale translation.  :-)

> A list works fine as a point of contact.  I note that in general, maintainers 
> are individuals (who delegate like mad, of course), because otherwise agenda 
> items languish with everyone thinking it's someone else's responsibility.

I agree; if we're going to have a language translated in
Documentation/<lang>, there ought to be one or two overall language
maintainer, plus a maintainer for each file that is being translated,
who is responsible for updating the translated file when the base
English Documentation file is updated.

					- Ted
