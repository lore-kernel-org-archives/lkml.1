Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbXHSOML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbXHSOML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 10:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbXHSOMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 10:12:00 -0400
Received: from relay5.ptmail.sapo.pt ([212.55.154.25]:49778 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751233AbXHSOL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 10:11:59 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Aug 2007 10:11:58 EDT
X-AntiVirus: PTMail-AV 0.3-0.91.1
Date: Sun, 19 Aug 2007 15:06:16 +0100
From: Jose Celestino <japc@co.sapo.pt>
To: Marc Perkel <mperkel@yahoo.com>
Cc: Willy Tarreau <w@1wt.eu>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Re: The vi editor causes brain damage
Message-ID: <20070819140615.GA3699@co.sapo.pt>
Mail-Followup-To: Marc Perkel <mperkel@yahoo.com>, Willy Tarreau <w@1wt.eu>,
	Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
References: <20070819072135.GQ6002@1wt.eu> <952949.96475.qm@web52503.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <952949.96475.qm@web52503.mail.re2.yahoo.com>
X-URL: http://xpto.org/~japc
X-System: Linux morgoth.sl.pt 2.6.22.1-41_1.cubbi_tuxonice.fc7
X-UP: 06:26:36 up 4 min,  3 users,  load average: 4.55, 2.11, 0.84
X-By: japc@morgoth.sl.pt
X-GPG-key-ID: 0x07B1363B
X-GPG-key-Fingerprint: D3F3 B47B F20C 3B1E 488C B949 1B8B 8141 07B1 363B
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Words by Marc Perkel [Sun, Aug 19, 2007 at 06:22:37AM -0700]:
> 
> --- Willy Tarreau <w@1wt.eu> wrote:
> 
> > On Sun, Aug 19, 2007 at 09:15:22AM +0200, Jiri Slaby
> > wrote:
> > > Marc Perkel napsal(a):
> > > > Let me give you and example of the difference
> > between
> > > > Linux open source world brain damaged thinking
> > and
> > > > what it's like out here in the real world.
> > > > 
> > > > Go to a directory with 10k files and type:
> > > > 
> > > > rm *
> > > > 
> > > > What do you get?
> > > > 
> > > > /bin/rm: Argument list too long
> > > 
> > > What does this have to do with rm command?
> > 
> > Nothing, and no more with linux development. Marc
> > confuses shell and rm.
> > Under DOS, when he types "del *", the shell calls
> > the builtin function
> > "del" and passes it only one argument "*". The del
> > function is then
> > responsible for iterating through the files using
> > getfirst/getnext.
> > 
> > This is also why mostly only builtin shell commands
> > support "*", while
> > most external commands do not support it, since they
> > have to re-implement
> > the same code to iterate through the files (try
> > "debug c*.com", it will
> > not work).
> > 
> > Under unix, the shell resolves "*" and passes the
> > 10000 file names to
> > the "rm" command. Now, execve() may fail because
> > 10000 names in arguments
> > can require too much memory. That's why find and
> > xargs were invented!
> > 
> > The solution is easy : find . -maxdepth 1 | xargs rm
> > 
> > So this has nothing to do with rm, nor with rm being
> > open-source, and
> > even less with rm being written with vi, and Marc's
> > rant is totally
> > wrong and off-topic. Maybe he was drunk when
> > posting, or maybe someone
> > used his keyboard to make him look like a complete
> > fool. Or maybe he
> > really is.
> > 
> > Willy
> > (please do not follow up on this OT thread,
> > responses to /dev/null)
> > 
> 
> The important point that you are missing here is that
> the Linux world is willing to live with an rm command
> that is broken and the Windows and DOS world isn't.
> This isn't about the rm command it's about programming
> standards. It's about that the Linux community isn't
> committed to getting it right.
> 

Yuhu! The rm command isn't broken (nothing is broken related to this).
Have you been reading? Can you even (read)?

Fscking troll.

-- 
Jose Celestino
----------------------------------------------------------------
http://www.msversus.org/     ; http://techp.org/petition/show/1
http://www.vinc17.org/noswpat.en.html
----------------------------------------------------------------
"And on the trillionth day, Man created Gods." -- Thomas D. Pate
