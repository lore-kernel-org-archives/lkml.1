Return-Path: <linux-kernel-owner+w=401wt.eu-S934393AbXGQQ3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934393AbXGQQ3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757046AbXGQQ3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:29:16 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:46877
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbXGQQ3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:29:15 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Tim Bird <tim.bird@am.sony.com>
Subject: Re: Documentation of kernel messages (Summary)
Date: Tue, 17 Jul 2007 12:29:08 -0400
User-Agent: KMail/1.9.6
Cc: Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, gh@us.ibm.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, joe@perches.com,
       auke-jan.h.kok@intel.com, hansendc@us.ibm.com, davem@davemloft.net,
       Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, linux-doc@vger.kernel.org
References: <1181747217.29512.9.camel@localhost.localdomain> <200707101225.32843.rob@landley.net> <469C0DF8.8080107@am.sony.com>
In-Reply-To: <469C0DF8.8080107@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707171229.10130.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 July 2007 8:31:52 pm Tim Bird wrote:
> Rob Landley wrote:
> > If you go to http://kernel.org/doc/ols you should find, nicely split up,
> > all the OLS papers from 2002-2007.
>
> Oooh!  That's nice!  I didn't notice the "nicely split up" part earlier.
> Any chance we can get the original docbook inputs that OLS uses
> for paper submissions?  Have you asked Andrew or Craig about this?

I've asked, but OLS was in the process of happening and they were kind of 
swamped...

> Also, it would be nice to correlate the talk names with the individual
> PDFs.

I'm working on that: http://kernel.org/doc/ols/2002

I keep getting distracted by new material coming in.  Need to shut it out for 
a bit and focus on processing the existing pile...

> Do you want me to solicit inside CELF for a volunteer for this?

Yes please.  I'm happy to have volunteers help out with any of this, if I can 
figure out how to sanely partition it.

I'm not just collating names with papers, I'm also reading the paper and 
trying to come up with a one page summary.  If you look at 
http://kernel.org/doc you'll see a (now stale) version of an index skeleton.  
I'd like to link to all these papers from one big index.  And also link the 
Documentation files into the same index.  And http://lwn.net/Kernel/Index/ 
and Linux Journal's archives and...

That's the hard part.  Indexing it.  Piling up a big heap is easy.

You'll notice that Documentation has its own 00-index file, which doesn't even 
refer to the make htmldocs output.  The lwn kernel material has an excellent 
index.  The Linux Journal articles have a chronological archive.  Every 
volume of OLS papers starts with a brief index.

And the problem is, every time somebody notices the problem they start a _new_ 
index that doesn't use any of the others.  (And they keep wanting to do it as 
a wiki, which dooms the project.  In my experience wikis aren't stable and 
only locally versioned.  They're not designed to be snapshotted as a coherent 
whole, which is the _point_ of an index.  If you deep-link into a wiki you 
get 404 errors after a while.  They're a good tool for the "piling up 
information" part, but a bad tool for editorial jobs like organizing and 
indexing existing information.  Wikis are designed to be decentralized, so 
the left hand doesn't have to know what the right hand is doing, but 
editorial functions is all about collating, coordinating, and correlating 
into a coherent whole.  Which is nontrivial.)

> We'd probably produce a wiki page of links, based on your
> list.txt file and the proceedings index.


I have a list.txt file?  (Rummages.)  Oh, that's actually extracted from Red 
Hat's 2007 OLS web page (see the link at top, "mirrored from here".)

I was using Red hat's broken-up pages (and pre-broken-up ones I found for 
2004) for a while, but I went back and I re-broke up the pages with my 
scripts (which you'll notice I link to; I want people other than me to be 
able to reproduce this.)  I did it because all the others I broke up have the 
two OLS boilerplate pages at the _end_ rather than the beginning, and I 
wanted to be consistent.

And that list.txt page doesn't have the paragraph per article summary (which I 
can sometimes take from the abstract, but even when there is an abstract it's 
often not what I need and I read the darn paper anyway to see what 
interesting stuff's buried in it).  I need that in order to index the 
articles, title isn't enough.  Some articles need to get linked from more 
than one place.  (James Bottomley's 2002 scsi paper has good "history of 
hotplug" material, for example.)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
