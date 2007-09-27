Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbXI0RUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbXI0RUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 13:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757300AbXI0RTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 13:19:53 -0400
Received: from mail.gmx.net ([213.165.64.20]:33250 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753797AbXI0RTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 13:19:52 -0400
Cc: hch@lst.de, geoff@gclare.org.uk, subrata@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 27 Sep 2007 19:19:50 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <Pine.LNX.4.64.0709271000420.763@alien.or.mcafeemobile.com>
Message-ID: <20070927171950.252220@gmx.net>
MIME-Version: 1.0
References: <46FB9FB9.8080201@gmx.net>
 <Pine.LNX.4.64.0709271000420.763@alien.or.mcafeemobile.com>
Subject: Re: Revised signalfd man-page
To: Davide Libenzi <davidel@xmailserver.org>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+LVJ9SDZSLPH/ftV1u0gXbrOjZ4X8kip1uN9sPHs
 HyC0Tk1HNEQzGxuiDN/pXT2t2bWwtxAhOc7A== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: AtTMce8bbGInb9/pFmVnJc1vcmZ1ZtyP
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Von: Davide Libenzi <davidel@xmailserver.org>
> On Thu, 27 Sep 2007, Michael Kerrisk wrote:
[...]
> > .\" FIXME Davide, what does the following mean?  How (in userspace
> > .\" terms) does a sighand structure become orphaned?
> > The
> > .BR read (2)
> > call can also return 0,
> > in case the sighand structure to which the signalfd was attached,
> > has been orphaned.
> 
> You can remove the five lines above, in virtue of the fact that Linus 
> merged my simplification patch.

Okay.

[...]
> > .\" FIXME Davide, a question: why rename these fields to be
> > .\" different from their siginfo_t counterparts?  At the very least,
> > .\" it would have been nicer to use the same names with prefixes
> > .\" such as (say) "fdsi_" (thus, e.g., fdsi_signo); that would have
> > .\" made grepping both kernel and userland source code easier
> > .\" (e.g, to find instances of "si_signo" in a siginfo_t or a
> > .\" signalfd_siginfo structure), and also would have avoided
> > .\" weirdnesses like trimming "errno" down to err.
> > .\"
> 
> That is fine for me. I'd like ssi_* (for Signalfd SigInfo). Ok?

Yes, equally good.  Would you write a patch for this, and 
CC me please?

Thanks,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.

