Return-Path: <linux-kernel-owner+w=401wt.eu-S933954AbXGQQnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954AbXGQQnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbXGQQmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:42:52 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:51828
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbXGQQmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:42:50 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Documentation of kernel messages (Summary)
Date: Tue, 17 Jul 2007 12:42:45 -0400
User-Agent: KMail/1.9.6
Cc: Tim Bird <tim.bird@am.sony.com>, Adrian Bunk <bunk@stusta.de>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, gh@us.ibm.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, joe@perches.com,
       auke-jan.h.kok@intel.com, hansendc@us.ibm.com, davem@davemloft.net,
       Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, linux-doc@vger.kernel.org
References: <1181747217.29512.9.camel@localhost.localdomain> <469C0DF8.8080107@am.sony.com> <469C18A8.5000808@zytor.com>
In-Reply-To: <469C18A8.5000808@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707171242.47362.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 July 2007 9:17:28 pm H. Peter Anvin wrote:
> Tim Bird wrote:
> > Oooh!  That's nice!  I didn't notice the "nicely split up" part earlier.
> > Any chance we can get the original docbook inputs that OLS uses
> > for paper submissions?  Have you asked Andrew or Craig about this?
>
> OLS uses LaTeX, not DocBook, for submissions AFAIK.

Yeah, but their retention of the original latex has been...  Iffy.  And their 
indexing was a bit rushed.  http://www.linuxsymposium.org/proceedings.php 
goes up to 2005.  If you go to 
http://www.linuxsymposium.org/2006/proceedings.php you'll see a mirror of the 
other page with 2006 added (why not update the top level one?  No idea.)  
Then 2007 is off on a Red Hat site (mis-numbered) and not even hosted on 
linuxsymposium.org.

If you look at http://kernel.org/doc/ols/2006/slides/ you'll notice I mirrored 
all the presentation slides (not the same as the papers).  Two of them had 
already gone down before I got there, but I managed to get a fresh copy of 
Steven Hill's uClibc NPTL slides when I bumped into him at OLS.  (My mirror 
has it, the original site it links to is 404.)  I still haven't tracked down 
Kristen Accardi's slides, and that's one that was theoretically mirrored on 
the OLS website itself, yet the link is 404...

I'm not complaining, by the way: busy people get the data out and then move 
on, it's up to people like me to go back and clean it up if you want any kind 
of data retention.  (And THEN you have to periodically figure out what's 
still relevant and what's only of historical interest.  Wheee...)

Right now, I'd be happy to just get the PDFs of 2001 and earlier.  There's a 
apparently one year they only have on paper, and one of the others is on a CD 
that Andrew thinks he knows where it is, but hadn't had time to dig up when 
last I poked him...

If latex shows up, I'm all for it.  But for now, I'm happy with the PDFs.  
(Hey Tim, you want something for a volunteer to do?  Index the 2006 papers, 
then match up the 2006 slides with the corresponding papers.  I can go 
through and add in summaries afterwards...  And note that the index.html 
should have _relative_ links, not absolute ones, because I want anyone to be 
able to tarball up the whole site and locally mirror it.  I need to do a big 
script that fetches the external things like the ols papers and breaks them 
up so you have reproducible local copies without blindly copying mine.  It's 
on my todo list...)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
