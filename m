Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbXINKuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbXINKuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 06:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbXINKuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 06:50:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061AbXINKuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 06:50:04 -0400
From: Andreas Schwab <schwab@suse.de>
To: 7eggert@gmx.de
Cc: Brent Casavant <bcasavan@sgi.com>, Gabor Gombas <gombasg@sztaki.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: O_NOLINK for open()
References: <92Haf-7z7-5@gated-at.bofh.it> <92TO5-246-1@gated-at.bofh.it>
	<92Zqu-2ur-1@gated-at.bofh.it> <E1IW8R4-0000ko-2z@be1.lrz>
X-Yow: Well, I'm a classic ANAL RETENTIVE!!  And I'm looking for a way to
 VICARIOUSLY experience some reason to LIVE!!
Date: Fri, 14 Sep 2007 12:50:03 +0200
In-Reply-To: <E1IW8R4-0000ko-2z@be1.lrz> (Bodo Eggert's message of "Fri\, 14
	Sep 2007 12\:30\:05 +0200")
Message-ID: <jek5qta5d0.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert <7eggert@gmx.de> writes:

> ~/tmp > cp /bin/sleep .
> ~/tmp > chmod u+s sleep
> ~/tmp > ./sleep 2147483647 &
> [1] 2823
> ~/tmp > strace -p 2823
> Process 2823 attached - interrupt to quit
> setup(

You didn't change the owner, so this is not a setuid execution.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
