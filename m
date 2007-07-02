Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbXGBJSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbXGBJSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 05:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbXGBJSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 05:18:11 -0400
Received: from ns1.suse.de ([195.135.220.2]:59881 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbXGBJSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 05:18:11 -0400
From: Andreas Schwab <schwab@suse.de>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [i386] Questions regarding provisional page tables initialization
References: <20070701203833.GA3498@Ahmed> <46882872.7040005@goop.org>
	<20070702011332.GA3503@Ahmed>
X-Yow: I've read SEVEN MILLION books!!
Date: Mon, 02 Jul 2007 11:18:08 +0200
In-Reply-To: <20070702011332.GA3503@Ahmed> (Ahmed S. Darwish's message of
	"Mon\, 2 Jul 2007 04\:13\:33 +0300")
Message-ID: <je8x9zrwof.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Ahmed S. Darwish" <darwish.07@gmail.com> writes:

> yes, but isn't the displacement here (0x007) a _bytes_ displacement ?. so
> effectively, %ecx now contains physical address of pg0 + 7bytes. Is it A 
> meaningful place/address ?.

It's not pg0 + 7bytes, it is pg0 plus 3 flag bits.  Since a page address
is always page aligned, the low bits are reused for flags.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
