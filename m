Return-Path: <linux-kernel-owner+w=401wt.eu-S939615AbXGTRk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939615AbXGTRk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932349AbXGTRks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:40:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:59129 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765785AbXGTRkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:40:47 -0400
From: Andreas Schwab <schwab@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andi Kleen <ak@novell.com>, Arthur Jones <arthur.jones@qlogic.com>,
       Vasily Tarasov <vtaras@openvz.org>, linux-kernel@vger.kernel.org,
       Jan Kara <jack@ucw.cz>, linux-arch@vger.kernel.org
Subject: Re: build fix for x86_64...
References: <617E1C2C70743745A92448908E030B2A01FA46A9@scsmsx411.amr.corp.intel.com>
	<46A0EAC8.9020203@zytor.com>
X-Yow: Thousands of days of civilians ...  have produced a...
 feeling for the aesthetic modules --
Date: Fri, 20 Jul 2007 19:40:44 +0200
In-Reply-To: <46A0EAC8.9020203@zytor.com> (H. Peter Anvin's message of "Fri\,
	20 Jul 2007 10\:03\:04 -0700")
Message-ID: <jezm1rq8gz.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> No, that would be bad.  If compat_u64 is used to carry 32-bit ABIs
> forward into 64-bit space without needing compatibility hacks, then this
> would actually introduce ABI incompatibilities depending on CONFIG_COMPAT!

But without CONFIG_COMPAT there is no 32-bit ABI, thus no need for
compat_u64 in the first place.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
