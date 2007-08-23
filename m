Return-Path: <linux-kernel-owner+w=401wt.eu-S1765730AbXHWXSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765730AbXHWXSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761553AbXHWXS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:18:27 -0400
Received: from xenotime.net ([66.160.160.81]:37681 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761269AbXHWXS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:18:27 -0400
Date: Thu, 23 Aug 2007 16:18:15 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Greg KH <gregkh@suse.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [GIT PATCH] USB fixes for 2.6.23-rc3
Message-Id: <20070823161815.604f1a8b.rdunlap@xenotime.net>
In-Reply-To: <20070823224956.GA25969@suse.de>
References: <20070822220805.GB30603@kroah.com>
	<Pine.LNX.4.60.0708240036200.3246@poirot.grange>
	<20070823224956.GA25969@suse.de>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 15:49:56 -0700 Greg KH wrote:

> On Fri, Aug 24, 2007 at 12:43:47AM +0200, Guennadi Liakhovetski wrote:
> > Hi Greg,
> > 
> > sorry, this is a private egoistic request, so I took the liberty and 
> > removed Linus and Andrew from CC: If this wouldn't make things more 
> > difficult / worse for you and anyone else, could you perhaps post such 
> > patch chains as a reply to the first message (patch 0/x) and not each 
> > subsequent patch as a reply to the previous one? It would make it easier 
> > to view for _me_ (remember egoistic?) because my mail agent (pine) 
> > presents mail threads where every reply level produces a small right 
> > offset in the subject line, so, starting from about reply number 20 the 
> > subject is completely off-screen.
> > 
> > Again, this is a minor trouble, and, perhaps, I am the only one suffering 
> > from it, but if it doesn't matter either way for everyone else, I would 
> > really appreciate it that way.
> 
> Heh, people ask me about this every few months or so, so you are not
> alone.

I'd prefer that change also.  In fact I just modified (trivial)
send_lots_of_email.pl (gregkh_patchbomb mailer) to do this,
except that I just have it create an mbox that I email via
msmtp.  (and it reads a 'sendpatchset' control file for input
instead of needing to modify the script source file itself)


> Unfortunately, I really like the cascade affect, it shows that the
> patches do have to be applied in consecutive order for them to work
> properly (which some people seem to forget and then get mad at me when
> they try to cherry-pick intermediate patches and apply them to older
> kernels for odd reasons...)

A patch series such as:

PATCH 0/n: intro/summary
|_ PATCH 1/n: desc1
|_ PATCH 2/n: desc2
|_ PATCH 3/n: desc3

should imply a patch order also, shouldn't it?  At least it does
to me and to users of Paul Jackson's 'sendpatchset' script,
which acts in this way.

> If I wanted to respond in an egotistical way, I could just tell you to
> use an email client that can handle the cascade affect properly, like
> mine does :)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
