Return-Path: <linux-kernel-owner+w=401wt.eu-S1760028AbXK1PXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbXK1PXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbXK1PXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:23:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbXK1PXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:23:01 -0500
From: Andreas Schwab <schwab@suse.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question regarding mutex locking
References: <474CF06C.8020208@lwfinger.net>
X-Yow: It's the RINSE CYCLE!!  They've ALL IGNORED the RINSE CYCLE!!
Date: Wed, 28 Nov 2007 16:22:57 +0100
In-Reply-To: <474CF06C.8020208@lwfinger.net> (Larry Finger's message of "Tue\,
	27 Nov 2007 22\:37\:00 -0600")
Message-ID: <jemysy2y3y.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> If a particular routine needs to lock a mutex, but it may be entered with that mutex already locked,
> would the following code be SMP safe?
>
> hold_lock = mutex_trylock()
>
> ...
>
> if (hold_lock)
> 	mutex_unlock()

When two CPUs may enter the critical region at the same time, what is
the point of the mutex?  Also, the first CPU may unlock the mutex while
the second one is still inside the critical region.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
