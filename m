Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbYHDQNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbYHDQNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYHDQM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:12:56 -0400
Received: from ns.suse.de ([195.135.220.2]:57979 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbYHDQMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:12:55 -0400
From: Andreas Schwab <schwab@suse.de>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext3 seems to ignore ECC errors
References: <20080804150353.GS4470@implementation.uk.xensource.com>
	<je8wvczt5x.fsf@sykes.suse.de>
	<20080804154727.GV4470@implementation.uk.xensource.com>
X-Yow: My DIGITAL WATCH has an automatic SNOOZE FEATURE!!
Date: Mon, 04 Aug 2008 18:12:54 +0200
In-Reply-To: <20080804154727.GV4470@implementation.uk.xensource.com> (Samuel
	Thibault's message of "Mon, 4 Aug 2008 16:47:27 +0100")
Message-ID: <jeiqugyd15.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault <samuel.thibault@ens-lyon.org> writes:

> Andreas Schwab, le Mon 04 Aug 2008 17:39:06 +0200, a écrit :
>> Samuel Thibault <samuel.thibault@ens-lyon.org> writes:
>> > However, to my surprise Linux (2.6.26) continued to mount the ext3
>> > filesystem read/write, spitting out a lot of IDE errors.  Shouldn't
>> > filesystems remount read-only and let the admin try to save data in such
>> > case?
>> 
>> That's a tunable parameter of the filesystem, see tune2fs(8).
>
> Oh, I had assumed it was on by default, hum.  But now it reads
>
> Errors behavior:          Remount read-only
>
> and I am still getting the same behavior.  Indeed after some VFS
> modifications time it gets remounted read-only, but shouldn't that
> happen as soon as possible?

The block device may do some retries before passing the error on.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
