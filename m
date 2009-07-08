Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbZGHKsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbZGHKsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbZGHKsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:48:32 -0400
Received: from mail.samba.org ([66.70.73.150]:56608 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbZGHKsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:48:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19028.31088.400461.939917@samba.org>
Date: Wed, 8 Jul 2009 20:48:16 +1000
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       Pavel Machek <pavel@ucw.cz>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <20090708110451.1092afa7@lxorguk.ukuu.org.uk>
References: <19013.8005.541836.436991@samba.org>
	<alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
	<19026.38137.63807.427511@samba.org>
	<200907072356.51553.Martin@lichtvoll.de>
	<19028.3736.892828.352905@samba.org>
	<20090708110451.1092afa7@lxorguk.ukuu.org.uk>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

 > There are lots of Win98 systems still alive out there. The "last few" in
 > the Win98 world is rather a lot due to the original enormous user base.

I find it rather ironic that you are advocating leaving the Linux
kernel open to further legal attacks by Microsoft because if we didn't
then we might lose compatibility with an operating system which
Microsoft themselves abandoned a long time ago.

 > I think we already proved it had no use upstream. Vendors will remove
 > the code from their source tree if worried about patents so including it
 > in the base tree is really irrelevant. So I find your argument about this
 > less than convincing.

we've been round this loop before. See my previous emails where I
explained why I think having it upstream is an advantage. See also the
reply from James.

 > I also note you keep talking about vendors. This is an open list yet I
 > don't hear a word from the vendors you claim to represent in support of
 > this patch set, and saying they would enable it. Not one voice seems to
 > have appeared.

I never claimed to represent any vendors. I said that it was my
opinion that many vendors will want to apply this patch, and you seem
to support that opinion as you've several times stated that you think
that vendors will apply it in an unconditional form.

 > At that point nobody managing risk is going to do anything but remove the
 > code that worries them. It's additional risk with no return.

Some vendors may well do that. Some may decide to keep it as a compile
time option. The legal advice that I've seen is that keeping it as a
compile time option is fine. 

If it's pulled out of kernel.org trees then:

 - each vendor may end up with slightly different varients. That means
   we could have Linux devices behaving inconsistently.

 - the testing and discussion may end up happening in a less open
   manner. I think the testing and discussion on lkml has been very
   valuable. As you've noted, vendors have not been actively
   participating in these discussions. Do you think they'll suddenly
   decide to start discussing things openly if we move it out of a
   kernel.org tree? You must know how reluctant vendors are to draw
   attention to themselves when it comes to patents.

 - some vendors may decide not to use Linux, and switch to embedded
   windows instead if we don't have a clearly supported way of
   avoiding these patents in the Linux kernels.

 - we'd be setting up the kernel to have a deliberate long term
   difference between what a large part of the user base runs and what
   is tested for kernel.org kernels. As I said previously, I think
   that is poor software engineering practice. I know you disagree,
   but I also know that some other people do agree. I suspect you
   would be more inclined to agree if this patch had nothing to do
   with patents.

I suspect you are right that many vendors would apply it anyway if it
wasn't in a kernel.org kernel. Is that sufficient to stop a new round
of lawsuits? Maybe. If that is what is decided then I guess we'll find
out over the next year or two.

Cheers, Tridge
