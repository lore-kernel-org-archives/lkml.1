Return-Path: <linux-kernel-owner+w=401wt.eu-S934697AbXGMNqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934697AbXGMNqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933753AbXGMNqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:46:25 -0400
Received: from THUNK.ORG ([69.25.196.29]:34505 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440AbXGMNqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:46:20 -0400
Date: Fri, 13 Jul 2007 09:43:53 -0400
From: Theodore Tso <tytso@mit.edu>
To: Li Yang <leoli@freescale.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Rob Landley <rob@landley.net>,
       Gerrit Huizenga <gh@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
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
Message-ID: <20070713134353.GB18684@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Li Yang <leoli@freescale.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Rob Landley <rob@landley.net>, Gerrit Huizenga <gh@us.ibm.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
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
References: <E1I7wsz-0007oJ-DE@w-gerrit.beaverton.ibm.com> <200707101212.38981.rob@landley.net> <1184163990.23373.46.camel@Gundam> <200707111413.03513.rob@landley.net> <20070711213234.GE19456@thunk.org> <20070713115321.23e3544f@the-village.bc.nu> <1184330940.23373.70.camel@Gundam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184330940.23373.70.camel@Gundam>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 08:49:00PM +0800, Li Yang wrote:
> On Fri, 2007-07-13 at 11:53 +0100, Alan Cox wrote:
> > > One thing that would be a VERY good idea is to make sure that each
> > > translated document is tagged with when it was last translated, and
> > > against which kernel version (using either a GIT commit id or a
> > 
> > The English versions need a last updated too, that way we would know when
> > they are past their best before date (as most of them are)
> 
> Good idea.  So a "last updated" date field will be required for both the
> English and translated documents.  Date will be more straight forward
> than using commit id, IMHO.

Well, date and kernel version id, then.  Otherwise they may be
confusion if the translator is using 2.6.16.35 as opposed to
2.6.22-git3, etc.  I would hope that the translator would always be
using only the latest development branch, but I wouldn't want to
always bet on that.  One advantage of using git commit id is that
there's no question about what the source document version was for the
translation.  It also makes it easier for the translator since they
can just diff between the last git commit id, and HEAD, and then
update their translation accordingly.

							- Ted
