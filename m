Return-Path: <linux-kernel-owner+w=401wt.eu-S1763303AbXHCTeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763303AbXHCTeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 15:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbXHCTdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 15:33:54 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:37479
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750988AbXHCTdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 15:33:50 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Documentation of kernel messages (Summary)
Date: Fri, 3 Aug 2007 15:32:04 -0400
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       leoli@freescale.com, Gerrit Huizenga <gh@us.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, gregkh@suse.de, pavel@ucw.cz,
       tim.bird@am.sony.com, arjan@infradead.org, sam@ravnborg.org,
       jengelh@computergmbh.de, joe@perches.com, auke-jan.h.kok@intel.com,
       hansendc@us.ibm.com, davem@davemloft.net, Valdis.Kletnieks@vt.edu,
       kenistoj@us.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       linux-doc@vger.kernel.org
References: <E1I7wsz-0007oJ-DE@w-gerrit.beaverton.ibm.com> <200707161553.07813.rob@landley.net> <20070803111155.fe9281f6.rdunlap@xenotime.net>
In-Reply-To: <20070803111155.fe9281f6.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708031432.05714.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 August 2007 1:11:55 pm Randy Dunlap wrote:
> On Mon, 16 Jul 2007 15:53:06 -0400 Rob Landley wrote:
> > On Sunday 15 July 2007 12:28:06 pm Randy Dunlap wrote:
> > > On Sat, 14 Jul 2007 21:56:15 -0400 Rob Landley wrote:
> > > > On Friday 13 July 2007 11:54:41 pm Randy Dunlap wrote:
> > > > > > If there's interest, I can push some patches to clean up
> > > > > > Documentation by moving files into subdirectories, but
> > > > > > Documentation's not well-suited to link out to the web.  (You
> > > > > > need html for that, and it's text.)
> > > > >
> > > > > I think that you should start moving Documentation/ files around
> > > > > and adding subdirectories -- if you are pretty sure of where they
> > > > > should go (i.e., they won't likely be moved again later on).
> > > >
> > > > You mean like these?
> > > > http://www.uwsg.iu.edu/hypermail/linux/kernel/0705.3/2925.html
> > > > http://www.uwsg.iu.edu/hypermail/linux/kernel/0705.3/2924.html
> > >
> > > Yes.  Have any of these been merged?
> >
> > Not that I know of.  They seemed to meet with resounding indifference, so
> > I went on to other things...
>
> You need to be persistent.  Please re-submit this.

Greg KH thinks it's a good idea to add language directories to the top level 
of Documentation, and there are slightly more than two of those:
http://www.translatorscafe.com/cafe/Help.asp?HelpID=59

Since you think it's worth doing, I'll resubmit the work I've already done 
here, but I no longer think trying to shovel Documentation into some 
semblance of order against the will of people like Greg is a good use of 
time.

These days I'm trying to create an html index that links into Documentation in 
a coherent order (with categories and everything), and using automated tools 
to detect files that aren't linked to, or links that point to a file that 
isn't there anymore.  This is obviously still a work in progress, but I think 
it's a better approach.

> and since it's just file & dir moves and done via git, it should go to
> Linus.  However, he may not want it right now since the primary
> merge window for 2.6.23 has closed (although he has been merging
> some other doc updates recently).

If moving text files from one location to another in the Documentation 
directory breaks the build or causes bugs in the kernel, we have bigger 
problems. :)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
