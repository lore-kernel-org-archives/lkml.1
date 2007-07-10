Return-Path: <linux-kernel-owner+w=401wt.eu-S1762096AbXGJTxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762096AbXGJTxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755670AbXGJTxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 15:53:41 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:36156
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754942AbXGJTxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 15:53:40 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: Documentation of kernel messages (Summary)
Date: Tue, 10 Jul 2007 15:53:34 -0400
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, tim.bird@am.sony.com, gh@us.ibm.com,
       arjan@infradead.org, sam@ravnborg.org, jengelh@computergmbh.de,
       joe@perches.com, auke-jan.h.kok@intel.com, hansendc@us.ibm.com,
       davem@davemloft.net, Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       linux-doc@vger.kernel.org
References: <1181747217.29512.9.camel@localhost.localdomain> <200707101225.32843.rob@landley.net> <20070710185415.GA3492@stusta.de>
In-Reply-To: <20070710185415.GA3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707101553.35587.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2007 14:54:15 Adrian Bunk wrote:
> On Tue, Jul 10, 2007 at 12:25:31PM -0400, Rob Landley wrote:
> >...
> > Let's look at _english_ documentation.
> >
> > If you go to http://kernel.org/doc/ols you should find, nicely split up,
> > all the OLS papers from 2002-2007.  By my count, there are 337 of them,
> > totaling 61.8 megabytes when they're split up like that.  Being PDFs,
> > they don't compress all that well.
> >
> > Which subset of these should be copied into the Documentation directory?
>
> You don't have to copy everything.
>
> And you anyway have to handle cases like e.g. most books where you are
> not permitted to copy them, but might want to point people to them.

This is exactly what I'm saying.  I don't want to copy the translated 
documentation, I want to point people to it.  Out on the web.  Where it's 
maintained by the people who translated it, which history says they're 
noticeably less likely to do with a copy.

> > How
> > do you update them?  This is the documentation from just ONE SOURCE.
>
> You aren't legally permitted to update any OLS paper unless you've
> gotten explicit permission by the author.

I wasn't planning to.  I'm pointing out that it's hard.

> And you shouldn't include non-free documentation into the kernel sources.

A) http://www.linuxsymposium.org/2007/cfp.php under "Publication Rights":

  Further, as stated in the official templates, and on the Credits page from
  the Proceedings of this year and prior years: "Authors retain copyright to
  all submitted papers, but have granted unlimited redistribution rights to
  all as a condition of submission."

So it's free as in speech but not beer.

B) I'm using these as examples of things to NOT merge into the kernel sources.  
Thank you for making my point.  There's a LOT of this stuff out there.

> > How does this help keep anything up to date?
>
> You can only update things you are legally and technically able to
> update. For the rest, you can only ship pointers like kernel-docs.txt.

As an english speaker, I am not technically able to update non-english 
documentation.  Since the only common language required of linux kernel 
developers has ever been English, only the english documentation makes sense 
to merge into the kernel tarball.  Merging anything else guarantees that the 
vast majority of the contributors will never be able to review or update it, 
so merging it into the kernel tarball does not result in extra review or 
maintenance.

Extrapolating the review benefits of C code that breaks the build for 
everybody if you do it wrong to chinese documentation you can't even 
_read_...  Apples and oranges, it's a false comparison.  I don't see how 
merging translations of documentation is ever likely to be a win.

> > Rob
>
> cu
> Adrian

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
