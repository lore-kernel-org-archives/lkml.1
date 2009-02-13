Return-Path: <linux-kernel-owner+w=401wt.eu-S1761486AbZBMW0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761486AbZBMW0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 17:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbZBMW0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 17:26:10 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:35088 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbZBMW0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 17:26:10 -0500
From: Junio C Hamano <junio@pobox.com>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Ingo Oeser <ioe-lkml@rameria.de>, Peter Zijlstra <peterz@infradead.org>,
       L-K <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: git-send-email
References: <1234451714.10603.22.camel@laptop>
 <20090212192104.GD15809@csclub.uwaterloo.ca>
 <1234477025.10603.38.camel@laptop> <200902131034.05814.ioe-lkml@rameria.de>
 <20090213163923.GE15809@csclub.uwaterloo.ca>
Date: Fri, 13 Feb 2009 14:25:58 -0800
Message-ID: <7vtz6y6kjt.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 4E84F40A-FA1D-11DD-A5C7-6F7C8D1D4FD0-77302942!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lsorense@csclub.uwaterloo.ca (Lennart Sorensen) writes:

> Split: 25 patch sets.
> Shallow: 56 patch sets.
> Deep: 6 patch sets.

This is an interesting datapoint.

FWIW, for the git mailing list, the stats are like Shallow=30 vs Deep=50
for a series longer than 3 patches (I stopped counting after looking at
5200 messages).

But I think these numbers are flawed, as it is very likely that much more
people on the git mailing list are using git-send-email, while on the
kernel list, a lot of patches do not even come from git.  To put it
another way, we shouldn't take the numbers from the git mailing list
samples as an indicator on the style preferred by the *readers*.  The
numbers that can be counted only show what the *senders* thought would be
acceptable to the readers, nothing more.

If you are advocating to change the default, please take the discussion to
the git mailing list.  As I already said, I personally am in favor of the
shallow kind, but I do not run dictatorship over there.

Also we cannot make a change based solely on what the kernel people have
recently done these days; it is not year 2005 anymore and git is used by
other projects as well.

Just like the kernel folks take regressions seriously to the point to say
breaking one person's working setup is worse than fixing a known bug that
affects many more people, I take changing any default seriously.  Most
discussions to change the default come from poeple who do not like the
default for obvious reasons, and it is difficult to judge if there is a
silent majority that is content with the current behaviour, or everybody
is unhappy but only some care deeply enough to make loud noises about it.
We cannot tell these two cases apart very easily by only listening to the
loudness of voices of complaining people.

Thanks.
