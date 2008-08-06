Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYHFVxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYHFVxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYHFVxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:53:09 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:58375 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752567AbYHFVxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:53:06 -0400
Date: Wed, 6 Aug 2008 17:52:44 -0400
From: Theodore Tso <tytso@mit.edu>
To: Eric Paris <eparis@redhat.com>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       malware-list@lists.printk.net, linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
Message-ID: <20080806215244.GA21462@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Paris <eparis@redhat.com>, Greg KH <greg@kroah.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, malware-list@lists.printk.net,
	linux-kernel@vger.kernel.org
References: <20080804223249.GA10517@kroah.com> <1217896374.27684.53.camel@localhost.localdomain> <20080805005132.GA3661@kroah.com> <20080805122328.69a37c1d@lxorguk.ukuu.org.uk> <20080805170307.GB9639@kroah.com> <1217962602.27684.144.camel@localhost.localdomain> <20080805203007.GB27489@kroah.com> <1218048597.27684.276.camel@localhost.localdomain> <20080806210202.GA9413@mit.edu> <1218058081.5837.49.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218058081.5837.49.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 05:28:01PM -0400, Eric Paris wrote:
> > In this scenario, are you positing that you are worried about Windows
> > malware, or Linux malware?  What OS are the clients running?  I will
> > note that Windows has such a sucky NFS implementation that nearly all
> > Widows clients will be running CIFS/SMB, not NFS
> 
> I believe I specifically did not make any such claims at all about the
> client OS and merely claimed the intended target was not the linux NFS
> server.

I know you didn't say; that's why I asked.  :-)

I dispute your assertion that this quesiton is irrelevant.  It's
highly relevant, because if it's Windows clients, they ***won't*** be
using NFS.

As for other large desktop OS's, that would be MacOS and Linux;
anything else?  And the big, huge, vast difference between Windows and
MacOS/Linux is that with Windows, in practice people ran with
Administrator privileges because most applications (including at one
point Microsoft Visual Studio :-) died and/or completely refused to
install if you didn't have Administrator privileges.  So people very
regularly ran with Root privs.  With Vista, you no longer run with
root privileges by default --- instead, applications still assume they
have Administrator privileges, causing the Really Annoying Popup boxes
to pop up each time the application needs to do something that require
privileges --- which has trained users to mindlessly click "OK" each
time the Annoying Popup Box comes up.

Given that MacOS and Linux don't have these flaws with respect to
applications regularly expecting root privileges, will you admit that
perhaps some of the extreme scanning tactics that were required by
AntiVirus vendors might be not as necessary for "other desktops"?

Asking the question is important because if they are spending all of
their time on Windows virii, then your "elementary threat" is really
an "elementary strawman".  Or, at the very least, it's a low priority
effort, since the number of virii out in the field for Linux and MacOS
desktops is in the noise compared to Windows.  I know that it's
convenient for AV vendors to claim in their marketing literature that
this is only because Windows is more popular, but while that might be
part of it, it is also true that there are significant, structural
differences between Windows and those other large desktop candidates.

> Your argument is irrelevant for the threat given and you seem to have
> contorted the actual point of the statements to fit something else.  But
> I'm sure you a fan of multiple layers of security that you don't
> actually believe that "just check on the clients" is the right thing to
> do.

Giving up my water bottles and having to take off my shoes at airport
security has been justified in the name of "multiple layers of
security".  No, I'm NOT a fan of mindlessly using "defense in depth"
as an excuse for arbitrary amounts of security and giving up arbitrary
amounts of my private data.  You need to prove to me that from a cost
benefit tradeoff it's really worth it.

   	       	    	    	     	  	 - Ted
