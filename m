Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbYBOX2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbYBOX2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 18:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYBOX2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 18:28:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:58597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814AbYBOX2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 18:28:13 -0500
From: Andreas Schwab <schwab@suse.de>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: libc-alpha@sourceware.org, libc-alpha@sources.redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Linux i386 clone(): %ebx 'frobbing' ?
References: <20080215184228.GA6687@ubuntu> <jewsp69e5t.fsf@sykes.suse.de>
	<20080215230722.GA8012@ubuntu>
X-Yow: Hey, wait a minute!!  I want a divorce!!..  you're not Clint Eastwood!!
Date: Sat, 16 Feb 2008 00:28:11 +0100
In-Reply-To: <20080215230722.GA8012@ubuntu> (Ahmed S. Darwish's message of
	"Sat\, 16 Feb 2008 01\:07\:22 +0200")
Message-ID: <jeir0pajg4.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Ahmed S. Darwish" <darwish.07@gmail.com> writes:

> Hi Andreas,
>
> On Fri, Feb 15, 2008, Andreas Schwab wrote:
>> "Ahmed S. Darwish" <darwish.07@gmail.com> writes:
>> 
>> > I don't understand how the `fn' argument reached the child thread
>> > in the %ebx register. It's said in the comment that `fn' will be
>> > popped to child 'in the ebx frobbing below'. But what does that mean ?
>> 
>> See "popl %ebx" after "int $0x80".
>> 
>
> I hope I'm not misreading something obvious, but I can't find
> the code where FUNC(%esp) is stored in %ebx before %ebx value
> got pushed in the stack (and restored in above 'popl' statement).

It is stored in the new stack for the child, as explained in the
comment.  The parent has a different stack.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
