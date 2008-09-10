Return-Path: <linux-kernel-owner+w=401wt.eu-S1751907AbYIJJYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbYIJJYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 05:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYIJJYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 05:24:18 -0400
Received: from ns.suse.de ([195.135.220.2]:43767 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbYIJJYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 05:24:16 -0400
From: Andreas Schwab <schwab@suse.de>
To: John Wenker <jjw@pt.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: fstat(2) returns st_size==0 for non-empty FIFO.
References: <OFA045C5CB.E26ECC40-ON882574BF.007A7015-882574BF.007ED085@pt.com>
X-Yow: Darling, my ELBOW is FLYING over FRANKFURT, Germany..
Date: Wed, 10 Sep 2008 11:24:15 +0200
In-Reply-To: <OFA045C5CB.E26ECC40-ON882574BF.007A7015-882574BF.007ED085@pt.com>
	(John Wenker's message of "Tue, 9 Sep 2008 16:05:06 -0700")
Message-ID: <jehc8o9ww0.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Wenker <jjw@pt.com> writes:

> [1.] One line summary of the problem:
> fstat(2) returns st_size == 0 for a FIFO that is known to have data in it.

st_size has no meaning except for regular files and symlinks.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
