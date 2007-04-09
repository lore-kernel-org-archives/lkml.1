Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbXDIMqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbXDIMqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 08:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbXDIMqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 08:46:17 -0400
Received: from mail.suse.de ([195.135.220.2]:35079 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbXDIMqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 08:46:16 -0400
From: Andreas Schwab <schwab@suse.de>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: If not readdir() then what?
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com>
	<20070407203633.GA21555@thunk.org>
	<20070407233037.GA16508@infradead.org> <46193048.6000606@zytor.com>
	<20070408184129.GA20871@lazybastard.org>
	<20070408191955.GD29180@thunk.org> <46194260.3050900@zytor.com>
	<20070409014426.GA18580@thunk.org>
	<20070409110927.GA23240@lazybastard.org>
X-Yow: FIRST, I'm covering you with OLIVE OIL and PRUNE WHIP!!
Date: Mon, 09 Apr 2007 14:46:00 +0200
In-Reply-To: <20070409110927.GA23240@lazybastard.org> (=?iso-8859-1?Q?J=F6?=
 =?iso-8859-1?Q?rn?= Engel's message of
	"Mon, 9 Apr 2007 13:09:27 +0200")
Message-ID: <je6485af7b.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel <joern@lazybastard.org> writes:

> On Sun, 8 April 2007 21:44:26 -0400, Theodore Tso wrote:
>> 
>> Well, Joern thought that rm -rf might relying on the telldir cookie
>> being valid in precisely that circumstance.  If that is true, I'd
>> argue that this is a BUG in GNU coreutils that should be fixed...
>
> I heard it and accepted that claim without checking it.

There is not a single call to telldir/seekdir in the coreutils source.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
