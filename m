Return-Path: <linux-kernel-owner+w=401wt.eu-S1760868AbYBOUHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868AbYBOUHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbYBOUHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:07:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46262 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbYBOUHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:07:43 -0500
From: Andreas Schwab <schwab@suse.de>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: libc-alpha@sourceware.org, libc-alpha@sources.redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Linux i386 clone(): %ebx 'frobbing' ?
References: <20080215184228.GA6687@ubuntu>
X-Yow: In order to make PLANS for the WEEKEND...so that we can read RESTAURANT
 REVIEWS and decide to GO to that restaurant & then NEVER GO...so we can
 meet a FRIEND after work in a BAR and COMPLAIN about Interior Sect'y
 JAMES WATT until the SUBJECT is changed to NUCLEAR BLACKMAIL...and so
 our RELATIVES can FORCE us to listen to HOCKEY STATISTICS while we
 wait for them to LEAVE on the 7:48....
Date: Fri, 15 Feb 2008 21:07:42 +0100
In-Reply-To: <20080215184228.GA6687@ubuntu> (Ahmed S. Darwish's message of
	"Fri\, 15 Feb 2008 20\:42\:28 +0200")
Message-ID: <jewsp69e5t.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Ahmed S. Darwish" <darwish.07@gmail.com> writes:

> I don't understand how the `fn' argument reached the child thread
> in the %ebx register. It's said in the comment that `fn' will be
> popped to child 'in the ebx frobbing below'. But what does that mean ?

See "popl %ebx" after "int $0x80".

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
