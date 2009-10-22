Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbZJVTJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbZJVTJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 15:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbZJVTJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 15:09:06 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:41157 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbZJVTJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 15:09:05 -0400
Date: Thu, 22 Oct 2009 21:09:08 +0200
From: Andreas Mohr <andi@lisas.de>
To: Eugene Bordenkircher <eugebo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem with MDI/MDI-X auto-switching in E100 driver
Message-ID: <20091022190908.GA9002@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23b20494-1cea-41b6-a6ae-2b5f21fe5db8@g1g2000pra.googlegroups.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

bad devel, bad! Ought to have CC'd some other guys and me ;)
(just happened to stumble on it by accident)

> It seems a better solution to this is to trust the eeprom's configuration
> rather than override it.  Am I missing something or does this sound
> reasonable?

I don't have much actual experience with various e100 versions,
so I cannot confirm it, but if something like this gets implemented,
then it's perhaps best to restrict the possibly more dangerous
"trust eeprom" reverted logic to your chip version only.
Or is the "without magnetics" feature independent of particular chip
versions? Then of course that wouldn't help ;)

...and yet another edge case which e100 doesn't support as well as it
should. (would eepro100 have worked here?)
Anyway, one should just attempt to get it working nicely with e100,
no use complaining. :)

Andreas Mohr
