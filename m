Return-Path: <linux-kernel-owner+w=401wt.eu-S966165AbXEGSRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966165AbXEGSRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 14:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966153AbXEGSR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 14:17:28 -0400
Received: from mail.suse.de ([195.135.220.2]:40044 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966127AbXEGSR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 14:17:28 -0400
From: Andreas Schwab <schwab@suse.de>
To: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, hirofumi@mail.parknet.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: Long file names in VFAT broken with iocharset=utf8
References: <200705072151.20104.arvidjaar@mail.ru>
	<60F72760-C801-4F60-BF47-C661B4B5BE26@e18.physik.tu-muenchen.de>
X-Yow: CHUBBY CHECKER just had a CHICKEN SANDWICH in downtown DULUTH!
Date: Mon, 07 May 2007 20:17:15 +0200
In-Reply-To: <60F72760-C801-4F60-BF47-C661B4B5BE26@e18.physik.tu-muenchen.de>
	(Roland Kuhn's message of "Mon\, 7 May 2007 20\:07\:26 +0200")
Message-ID: <jebqgwpkgk.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de> writes:

> PATH_MAX specifically counts _bytes_ not characters, so UTF-8 does not
> matter. ISTR that PATH_MAX was 256 at some point, but I just  quickly
> grepped /usr/include and found various mention of 4096, so  where's the
> central repository for this configuration item? A hard- 
> coded value of 256 somewhere inside the kernel smells like a bug.

There is PATH_MAX and there is NAME_MAX, and only the latter (which is
260 for vfat) matters here.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
