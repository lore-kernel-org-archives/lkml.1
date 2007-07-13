Return-Path: <linux-kernel-owner+w=401wt.eu-S933425AbXGMSGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbXGMSGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759058AbXGMSFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:05:54 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41304
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759042AbXGMSFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:05:53 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Documentation of kernel messages (Summary)
Date: Fri, 13 Jul 2007 14:05:49 -0400
User-Agent: KMail/1.9.6
Cc: Theodore Tso <tytso@mit.edu>, leoli@freescale.com,
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
References: <E1I7wsz-0007oJ-DE@w-gerrit.beaverton.ibm.com> <20070711213234.GE19456@thunk.org> <20070713115321.23e3544f@the-village.bc.nu>
In-Reply-To: <20070713115321.23e3544f@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707131405.50143.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 July 2007 6:53:21 am Alan Cox wrote:
> > One thing that would be a VERY good idea is to make sure that each
> > translated document is tagged with when it was last translated, and
> > against which kernel version (using either a GIT commit id or a
>
> The English versions need a last updated too, that way we would know when
> they are past their best before date (as most of them are)

You can get this out of git annotate.  (Or in my case, hg annotate from 
http://kernel.org/hg/linux-2.6 .)

Cleaning up Documentation is on my todo list, but for this month I'm trying to 
integrate the existing Documentation files with things like the OLS papers, 
linux journal articles, lwn.net kernel articles, man-pages, and so on into 
one big index.  (Indexing it requires reading large chunks of it.  My brain 
hurts.)

If there's interest, I can push some patches to clean up Documentation by 
moving files into subdirectories, but Documentation's not well-suited to link 
out to the web.  (You need html for that, and it's text.)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
