Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbXIVXgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbXIVXgO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 19:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbXIVXf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 19:35:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbXIVXf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 19:35:58 -0400
From: Andreas Schwab <schwab@suse.de>
To: "John Z. Bohach" <jzb2@aexorsyst.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Should parent's WIFSIGNALED(siginfo->si_status) be true EVEN IF the SIGNAL was caught by the child?
References: <200709221122.09523.jzb2@aexorsyst.com>
	<517f3f820709221149x761abea8vf7e3529f0f3ddc64@mail.gmail.com>
	<200709221318.53579.jzb2@aexorsyst.com>
X-Yow: You were s'posed to laugh!
Date: Sun, 23 Sep 2007 01:35:56 +0200
In-Reply-To: <200709221318.53579.jzb2@aexorsyst.com> (John Z. Bohach's message
	of "Sat\, 22 Sep 2007 13\:18\:53 -0700")
Message-ID: <jezlzeuvc3.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"John Z. Bohach" <jzb2@aexorsyst.com> writes:

>     if (WIFEXITED(siginfo->si_status))

That does not make any sense.  si_status is _not_ a wait status.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
