Return-Path: <linux-kernel-owner+w=401wt.eu-S1760405AbXILWET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405AbXILWET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 18:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbXILWEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 18:04:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43179 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108AbXILWEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 18:04:10 -0400
From: Andreas Schwab <schwab@suse.de>
To: Brent Casavant <bcasavan@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: O_NOLINK for open()
References: <20070912144128.D5573@pkunk.americas.sgi.com>
X-Yow: I'm having an emotional outburst!!
Date: Wed, 12 Sep 2007 23:42:37 +0200
In-Reply-To: <20070912144128.D5573@pkunk.americas.sgi.com> (Brent Casavant's
	message of "Wed\, 12 Sep 2007 15\:37\:44 -0500 \(CDT\)")
Message-ID: <jetzpza7ci.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brent Casavant <bcasavan@sgi.com> writes:

> I could mmap a temporary tmpfs file (tmpfs so that if there is a
> machine crash no sensitive data persists) which is created with
> permissions of 0, immediately unlink it, and pass the file
> descriptor through an AF_UNIX socket.  This does open up a very
> small window of vulnerability if another process is able to chmod
> the file and open it before the unlink.

Only the owner can chmod a file, so why is that a vulnerability?

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
