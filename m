Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbXCZKBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbXCZKBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965136AbXCZKBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:01:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964959AbXCZKBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:01:32 -0400
From: Andreas Schwab <schwab@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: sata-vsc broken on SGI Prism
References: <je8xdnova3.fsf@sykes.suse.de>
	<20070325012044.97dc14fc.akpm@linux-foundation.org>
X-Yow: I will establish the first SHOPPING MALL in NUTLEY, New Jersey...
Date: Mon, 26 Mar 2007 12:01:25 +0200
In-Reply-To: <20070325012044.97dc14fc.akpm@linux-foundation.org> (Andrew
	Morton's message of "Sun, 25 Mar 2007 01:20:44 -0800")
Message-ID: <jevegob9xm.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Sat, 24 Mar 2007 10:17:24 +0100 Andreas Schwab <schwab@suse.de> wrote:
>
>> I'm getting this panic when loading sata-vsc on a SGI Prism:
>
> With what kernel?

It's still the same with 2.6.21-rc5.

>> Bisection has identified this patch (together with the follow-up patch to
>> fix the compilation failure):
>> 
>> commit 7cbaa86b937b0b1fab95c159989f6a3c00bbcf78
>> Author: Dan Wolstenholme <daniel@wolstenholme.net>
>> Date:   Tue Jan 9 05:59:21 2007 -0500
>> 
>>     [libata] sata_vsc: support PCI MSI
>>     
>>     Signed-off-by: Jeff Garzik <jeff@garzik.org>
>> 
>
> It seems that little of that patch remains present in current mainline.

I'd guess the real bug is in the SN code.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
