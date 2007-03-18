Return-Path: <linux-kernel-owner+w=401wt.eu-S1750827AbXCRVeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750827AbXCRVeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 17:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXCRVeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 17:34:19 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:56779 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbXCRVeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 17:34:18 -0400
X-Originating-Ip: 74.109.98.130
Date: Sun, 18 Mar 2007 17:06:13 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Jiri Kosina <jikos@jikos.cz>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: whence CONFIG_PROVE_SPIN_LOCKING?
In-Reply-To: <Pine.LNX.4.64.0703182156550.12394@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0703181655430.28474@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703181619540.19832@CPE00045a9c397f-CM001225dbafb6>
 <Pine.LNX.4.64.0703182156550.12394@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1223841700-1174251926=:28474"
Content-ID: <Pine.LNX.4.64.0703181705330.28474@CPE00045a9c397f-CM001225dbafb6>
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, TW_NL 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1223841700-1174251926=:28474
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.64.0703181705331.28474@CPE00045a9c397f-CM001225dbafb6>

On Sun, 18 Mar 2007, Jiri Kosina wrote:

> On Sun, 18 Mar 2007, Robert P. J. Day wrote:
>
> > $ grep -r PROVE_SPIN_LOCKING *
> > Documentation/irqflags-tracing.txt:CONFIG_TRACE_IRQFLAGS_SUPPORT is needed for CONFIG_PROVE_SPIN_LOCKING
> > kernel/spinlock.c:#ifdef CONFIG_PROVE_SPIN_LOCKING
>
> This should almost certainly be CONFIG_PROVE_LOCKING ... ?

actually, no, i found this web page:

http://www.ussg.iu.edu/hypermail/linux/kernel/0606.0/0527.html

which refers to a number of related "PROVE" options.  what their
status is these days is not clear, but i'm just pointing out that
someone is testing the one above when it can't possibly be set
anywhere.

rday

p.s.  just FYI, i ran my "find dead CONFIG variables" script on the
entire tree and, as we speak, there are 316 preprocessor tests that
are testing variables of the form "CONFIG_whatever" for which that
option is not set anywhere in the tree.  (that is, 316 distinct
variables, not just 316 distinct tests.)  see the attached script and
feel free to run it from the top of the tree on your favourite
directory or sub-directory.

i'm not saying every one of those examples represents an error.  some
of those might be set in a makefile, etc.  but it's enlghtening to run
it anyway to see the output.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
--0-1223841700-1174251926=:28474
Content-Type: APPLICATION/X-SH; NAME=dc.sh
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0703181705260.28474@CPE00045a9c397f-CM001225dbafb6>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=dc.sh

IyEvYmluL3NoCgojICBSdW4gZnJvbSB0b3Agb2Yga2VybmVsIHNvdXJjZSB0
cmVlLCBhcyBpbjoKIwojICAkIGRjLnNoIHNvdW5kCiMgICQgZGMuc2gga2Vy
bmVsCiMgICQgZGMuc2ggYXJjaAojICAkIGRjLnNoIGZzL3hmcwojICAkIGRj
LnNoCQkoZW50aXJlIHRyZWUpCgpESVI9JHsxLSp9CgpDVkFSUz0kKGZpbmQg
JHtESVJ9IC1uYW1lICIqLltjaF0iIHwJXAoJeGFyZ3MgaWZuYW1lcyB8CQkJ
XAoJZ3JlcCAiXkNPTkZJR18iIHwJCVwKCWN1dCAtZCcgJyAtZjEgfAkJCVwK
CXNlZCAicy9eQ09ORklHXy8vIiB8CQlcCglzZWQgInMvX01PRFVMRSQvLyIg
fAkJXAoJc29ydCAtdSkKCmtjZmlsZXM9JChmaW5kIC4gLW5hbWUgIktjb25m
aWcqIikKCmZvciBjdiBpbiAke0NWQVJTfSA7IGRvCglncmVwIC13cSAke2N2
fSAke2tjZmlsZXN9IHx8IHsKCQllY2hvICJDT05GSUdfJHtjdn0iCgkJZ3Jl
cCAtcncgIkNPTkZJR18ke2N2fSIgKgoJCWdyZXAgLXJ3ICIke2N2fSIgKgoJ
fQpkb25lCg==

--0-1223841700-1174251926=:28474--
