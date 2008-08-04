Return-Path: <linux-kernel-owner+w=401wt.eu-S1756424AbYHDPjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbYHDPjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 11:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbYHDPjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 11:39:10 -0400
Received: from ns2.suse.de ([195.135.220.15]:57164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbYHDPjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 11:39:09 -0400
From: Andreas Schwab <schwab@suse.de>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext3 seems to ignore ECC errors
References: <20080804150353.GS4470@implementation.uk.xensource.com>
X-Yow: ..  My pants just went on a wild rampage through
 a Long Island Bowling Alley!!
Date: Mon, 04 Aug 2008 17:39:06 +0200
In-Reply-To: <20080804150353.GS4470@implementation.uk.xensource.com> (Samuel
	Thibault's message of "Mon, 4 Aug 2008 16:03:53 +0100")
Message-ID: <je8wvczt5x.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault <samuel.thibault@ens-lyon.org> writes:

> However, to my surprise Linux (2.6.26) continued to mount the ext3
> filesystem read/write, spitting out a lot of IDE errors.  Shouldn't
> filesystems remount read-only and let the admin try to save data in such
> case?

That's a tunable parameter of the filesystem, see tune2fs(8).

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
