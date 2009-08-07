Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbZHGPbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbZHGPbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZHGPbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:31:08 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60433 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbZHGPbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:31:07 -0400
Date: Fri, 7 Aug 2009 11:16:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Chris Clayton <chris2553@googlemail.com>
Cc: Frans Pop <elendil@planet.nl>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, mcgrof@gmail.com
Subject: Re: ath5k - strange regulatory domain change
Message-ID: <20090807151304.GE7545@tuxdriver.com>
References: <c6b1100b0908070350t3101030bs4b3d2e7485ad9aee@mail.gmail.com> <200908071324.45269.elendil@planet.nl> <c6b1100b0908070556sb3f4f80sc757d8b100cbcb3c@mail.gmail.com> <20090807134803.GA7545@tuxdriver.com> <c6b1100b0908070757t7b973180s17959e0f46347d5d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c6b1100b0908070757t7b973180s17959e0f46347d5d@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 03:57:30PM +0100, Chris Clayton wrote:
> 2009/8/7 John W. Linville <linville@tuxdriver.com>:
> > On Fri, Aug 07, 2009 at 01:56:43PM +0100, Chris Clayton wrote:

> >> To sum this up then (as I understand things):
> >>
> >> 1. I am the system administrator (root);
> >> 2. I am using a valid (albeit deprecated from 2.6.31) method to tell
> >> the wireless infrastructure that I want the regulatory domain set to
> >> GB;
> >> 3. GB is a valid code; and
> >> 4. the wireless infrastructure sets the regulatory domain to CN.
> >> 5. in 2.6.30, the wireless infrastructure does what I (the root user)
> >> tell it to do.
> >>
> >> That's a regression in my book. Oh well! I do have the iw and crda
> >> applications installed, so I've taken that route of setting the
> >> regulatory domain to GB.
> >
> > Are you actually getting the wrong regulatory rules enforced?  Or are
> > you merely bothered that it is reporting "CN" instead of "GB"?
> >
> 
> I'm not sure whether it's wrong or not. To these dmesg snippets from
> my original post look wrong because one of the frequency ranges listed
> for CN is outside those listed for GB and one of the CN max_eirp
> entries is not preent in the GB list. Whether that is OK or not I
> don't know and can't find (lay user) documentation to tell me.
> 
> cfg80211: Regulatory domain changed to country: GB
>         (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>         (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>         (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>         (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>         (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
> 
> cfg80211: Regulatory domain changed to country: CN
>         (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>         (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>         (5735000 KHz - 5835000 KHz @ 40000 KHz), (N/A, 3000 mBm)

It looks like a mismatch to me.  Luis, can you sort this out?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
