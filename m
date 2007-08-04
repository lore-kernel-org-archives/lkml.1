Return-Path: <linux-kernel-owner+w=401wt.eu-S1765762AbXHDTCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765762AbXHDTCg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 15:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765113AbXHDTC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 15:02:28 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:39386
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760058AbXHDTC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 15:02:26 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Greg KH <gregkh@suse.de>
Subject: Re: Documentation of kernel messages (Summary)
Date: Sat, 4 Aug 2007 15:02:16 -0400
User-Agent: KMail/1.9.6
Cc: Randy Dunlap <rdunlap@xenotime.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Theodore Tso <tytso@mit.edu>, leoli@freescale.com,
       Gerrit Huizenga <gh@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, pavel@ucw.cz, tim.bird@am.sony.com,
       arjan@infradead.org, sam@ravnborg.org, jengelh@computergmbh.de,
       joe@perches.com, auke-jan.h.kok@intel.com, hansendc@us.ibm.com,
       davem@davemloft.net, Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       linux-doc@vger.kernel.org
References: <E1I7wsz-0007oJ-DE@w-gerrit.beaverton.ibm.com> <200708031432.05714.rob@landley.net> <20070804035038.GA23330@suse.de>
In-Reply-To: <20070804035038.GA23330@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708041402.19078.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 August 2007 10:50:38 pm Greg KH wrote:
> On Fri, Aug 03, 2007 at 03:32:04PM -0400, Rob Landley wrote:
> > On Friday 03 August 2007 1:11:55 pm Randy Dunlap wrote:
> > > On Mon, 16 Jul 2007 15:53:06 -0400 Rob Landley wrote:
> > > > On Sunday 15 July 2007 12:28:06 pm Randy Dunlap wrote:
> > > > > On Sat, 14 Jul 2007 21:56:15 -0400 Rob Landley wrote:
> > > > > > On Friday 13 July 2007 11:54:41 pm Randy Dunlap wrote:
> > > > > > > > If there's interest, I can push some patches to clean up
> > > > > > > > Documentation by moving files into subdirectories, but
> > > > > > > > Documentation's not well-suited to link out to the web.  (You
> > > > > > > > need html for that, and it's text.)
> > > > > > >
> > > > > > > I think that you should start moving Documentation/ files
> > > > > > > around and adding subdirectories -- if you are pretty sure of
> > > > > > > where they should go (i.e., they won't likely be moved again
> > > > > > > later on).
> > > > > >
> > > > > > You mean like these?
> > > > > > http://www.uwsg.iu.edu/hypermail/linux/kernel/0705.3/2925.html
> > > > > > http://www.uwsg.iu.edu/hypermail/linux/kernel/0705.3/2924.html
> > > > >
> > > > > Yes.  Have any of these been merged?
> > > >
> > > > Not that I know of.  They seemed to meet with resounding
> > > > indifference, so I went on to other things...
> > >
> > > You need to be persistent.  Please re-submit this.
> >
> > Greg KH thinks it's a good idea to add language directories to the top
> > level of Documentation, and there are slightly more than two of those:
> > http://www.translatorscafe.com/cafe/Help.asp?HelpID=59
> >
> > Since you think it's worth doing, I'll resubmit the work I've already
> > done here, but I no longer think trying to shovel Documentation into some
> > semblance of order against the will of people like Greg is a good use of
> > time.
>
> My "will" is only that some of these documents be translated _and_ put
> in the main kernel source tree.  I really have no opinion on where they
> need to go within that directory.  If you have a better place for them,
> please let me know.

A common subdirectory.  I'd probably put it in "Documentation/translated" with 
a README at the top level of that explaining what it's for.

I can push a patch to move them, but reorganizing Documentation doesn't turn 
it into an index that can link out resources outside itself.  If reorganizing 
it to be less of a compost heap is a separate goal in and of itself, I can do 
that...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
