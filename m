Return-Path: <linux-kernel-owner+w=401wt.eu-S1758410AbYLPQTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410AbYLPQTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758037AbYLPQS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:18:57 -0500
Received: from ns2.suse.de ([195.135.220.15]:34164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758027AbYLPQS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:18:56 -0500
From: Andreas Schwab <schwab@suse.de>
To: ptb@inv.it.uc3m.es
Cc: "Johannes Weiner" <hannes@cmpxchg.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
Subject: Re: time_is_after_jiffies misnomer
References: <200812161517.mBGFHUE07109@inv.it.uc3m.es>
X-Yow: Yow!!  That's a GOOD IDEA!!  Eating a whole FIELD of COUGH MEDICINE
 should make you feel MUCH BETTER!!
Date: Tue, 16 Dec 2008 17:18:54 +0100
In-Reply-To: <200812161517.mBGFHUE07109@inv.it.uc3m.es> (Peter T. Breuer's
	message of "Tue, 16 Dec 2008 16:17:30 +0100 (MET)")
Message-ID: <jeabawccup.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Peter T. Breuer" <ptb@inv.it.uc3m.es> writes:

> Look at the two:
>
>    the current time is later than foo jiffies
>                  |   |  |           `/.
>                time_is_after_jiffies(foo)

It's not "foo jiffies", it's time "foo" vs time "jiffies" (where jiffies
is the well known global variable).

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
