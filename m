Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbZEKChL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbZEKChL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 22:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZEKCg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 22:36:56 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:50892 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbZEKCgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 22:36:55 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
References: <20090509143742.GA27663@kroah.com>
	<20090509150853.GA32394@suse.de>
	<20090509082233.32cbb8e4@infradead.org> <20090509161923.GA942@suse.de>
	<20090509223454.4642753d.akpm@linux-foundation.org>
	<20090510152005.GA9461@suse.de> <1241980263.9562.380.camel@laptop>
	<20090510221901.30c1c5a5@lxorguk.ukuu.org.uk>
	<ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com>
	<20090510170016.1e3a4d97@infradead.org>
	<ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 10 May 2009 19:36:46 -0700
In-Reply-To: <ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com> (Kay Sievers's message of "Mon\, 11 May 2009 03\:22\:53 +0200")
Message-ID: <m1pregmkld.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, greg@kroah.com, fabio.comolli@gmail.com, akpm@linux-foundation.org, gregkh@suse.de, peterz@infradead.org, alan@lxorguk.ukuu.org.uk, arjan@infradead.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> On Mon, May 11, 2009 at 02:00, Arjan van de Ven <arjan@infradead.org> wrote:
>> (and it seems to be irrelevant to the devtmpfs discussion anyway since
>> Eric Biederman has shown that pulling the device numbers out of sysfs
>> is basically free... even though it'd be nice to give that some help to
>> make it a nice index)

> Devtmpfs is the simplest, is the fastest, is the most reliable, and it
> is the most flexible 

FLEXIBLE?

> option for us. And still, nobody will be forced
> to use it, it's entirely optional. For our systems, we decided to do
> it that way, and we ship it already in the distro, and if there are no
> substantial problems coming up, which we don't expect, we will
> continue using it.

Yes but you are asking all of us to maintain it.  Forever in perpetuity.
A better case needs to be made than you have already shipped the code.

I'm sorry you decided to ship the code before getting a review.  I
guess that is the definition of an experimental feature.  One not in
the upstream kernel.

> You might not like it for whatever reason.

I think your justification for this ``feature'' is strongly flawed.

You claim to save 2 seconds of a process that should take less than
a tenth of a second.

You claim flexibility while removing user space from the policy loop.

You claim speed increases when comparing to a dog slow non-tuned
implementation.

> And we consider this problem as solved.

What backroom have you had that discussion?

You are presenting this as a decision already made.  I think you
are not playing well with others.

I don't see a case having been made that the existing user
space interface is broken.  Just that the udev implementation
is slow.

I think a slow user space application is simply not a justification
for putting code in the kernel.

I think a developer using faulty arguments for their code likely
has not thought things through and that is enough reason to call
suspicion onto the code in my opinion.

Eric
