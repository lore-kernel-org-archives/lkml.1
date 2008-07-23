Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbYGWObk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbYGWObk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 10:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYGWObb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 10:31:31 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53096 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797AbYGWOba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 10:31:30 -0400
X-Sasl-enc: DfPPkeo9H6PyuIHJh7W5sPSUtklJf5zBoQ1F7ZqBOqPM 1216823488
Date: Wed, 23 Jul 2008 11:31:25 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: pageexec@freemail.hu
Cc: "Rodrigo Rubira Branco (BSDaemon)" <rbranco@la.checkpoint.com>,
       Greg KH <gregkh@suse.de>, Alan Cox <alan@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com,
       "'Justin Forbes'" <jmforbes@linuxtx.org>,
       "'Zwane Mwaikambo'" <zwane@arm.linux.org.uk>,
       "'Theodore Ts'o'" <tytso@mit.edu>,
       "'Randy Dunlap'" <rdunlap@xenotime.net>,
       "'Dave Jones'" <davej@redhat.com>,
       "'Chuck Wolber'" <chuckw@quantumlinux.com>,
       "'Chris Wedgwood'" <reviews@ml.cw.f00f.org>,
       "'Michael Krufky'" <mkrufky@linuxtv.org>,
       "'Chuck Ebbert'" <cebbert@redhat.com>,
       "'Domenico Andreoli'" <cavokz@gmail.com>, "'Willy Tarreau'" <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, caglar@pardus.org.tr, casey@schaufler-ca.com,
       spender@grsecurity.net, rodrigo@kernelhacking.com
Subject: Re: [stable] Linux 2.6.25.10 (resume)
Message-ID: <20080723143125.GB4684@khazad-dum.debian.net>
References: <20080723042737.GC6784@suse.de> <48873827.12054.433CA4FB@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48873827.12054.433CA4FB@pageexec.freemail.hu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2008, pageexec@freemail.hu wrote:
> On 22 Jul 2008 at 21:27, Greg KH wrote:
> > >  2) Disclosure
> > >  
> > >  The goal of the Linux kernel security team is to work with the
> > >  bug submitter to bug resolution as well as disclosure.  We prefer
> > > -to fully disclose the bug as soon as possible.  It is reasonable to
> > > +to not disclose the bug, since we believe any kind of bug deserves the
> > > +same attention and will be quickly patched.  It is reasonable to
> > 
> > No, again, you are using the word "disclose" in an odd way here.
> > 
> > Of course the bug is "disclosed" in that it is made public, "here's a
> > fix for foo breaking".
> 
> it's apparently not true when foo = "kernel's security model", hence the
> suggested change to reflect reality.

I heavily suggest using something else than "disclose".  

For the security community, "disclose" doesn't mean you have the source code
for the buggy code and the source code for the fix.  It means you have the
information that it is a "foo = kernel's security model" bug, and a
description of the consequences of the bug for foo (the security model).

This is NOT what "disclose" means for the Linux kernel, right now.  Here,
"disclose" means "you know there is a bug, you have the code, you have the
bug fix".  But you don't know that "foo = kernel's security bug", or the
consequences of the bug for the security model.

So just use another word, or properly qualify WHAT is going to be disclosed,
(and in this case, WHAT is not going to be *usually* disclosed).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
