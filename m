Return-Path: <linux-kernel-owner+w=401wt.eu-S933790AbZIDSbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790AbZIDSbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 14:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757170AbZIDSbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 14:31:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54209 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbZIDSbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 14:31:20 -0400
Date: Fri, 4 Sep 2009 20:31:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, sam@ravnborg.org, tglx@linutronix.de,
       David.Woodhouse@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kbuild] x86: Don't silently override CONFIG_64BIT in
	'make oldconfig'
Message-ID: <20090904183103.GA1873@elte.hu>
References: <tip-5a8a2d13b1526e306ff2a9fe12dc9d5878d355f9@git.kernel.org> <20090904144857.GA12872@elte.hu> <alpine.LFD.2.00.0909041631210.14872@twosheds.infradead.org> <4AA13FE6.20807@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA13FE6.20807@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 09/04/2009 08:33 AM, David Woodhouse wrote:
> > On Fri, 4 Sep 2009, Ingo Molnar wrote:
> > 
> > 
> >>> x86: Don't silently override CONFIG_64BIT in 'make oldconfig'
> >>
> >> -tip testing found that this commit broke the UML build:
> >>
> >> /home/mingo/tip/arch/um/Makefile:52:
> >> /home/mingo/tip/arch/um/Makefile-x86: No such file or directory
> >> make[1]: *** No rule to make target
> >> `/home/mingo/tip/arch/um/Makefile-x86'.  Stop.
> >> make: *** [sub-make] Error 2
> > 
> > Hm, doesn't that mean that UML has always been broken for ARCH=x86?
> 
> Quite possible.  ARCH=x86 hasn't exactly been widely used.

Note, i used 'make ARCH=um' so this commit cannot be pushed upwards 
until this problem is fixed. It could very well be some missing 
changes on the UML side.

	Ingo
