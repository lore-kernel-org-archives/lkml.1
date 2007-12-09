Return-Path: <linux-kernel-owner+w=401wt.eu-S1751138AbXLIShE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138AbXLIShE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 13:37:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbXLISgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 13:36:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41904 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751170AbXLISgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 13:36:53 -0500
Date: Sun, 9 Dec 2007 10:36:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
In-Reply-To: <20071209134217.7ff02dd2@the-village.bc.nu>
Message-ID: <alpine.LFD.0.9999.0712091035310.12046@woody.linux-foundation.org>
References: <200712080340.49546.rjw@sisk.pl> <20071208015227.3a1c7fae.akpm@linux-foundation.org> <475B9270.6070902@gmail.com> <20071209134217.7ff02dd2@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 9 Dec 2007, Alan Cox wrote:
>
> > If we fail to find out the solution in time, we always have the
> > alternative of backing out the ATAPI transfer chunk size update.  This
> 
> Which will break far more controllers and drives than it fixes, so
> backing it out is nonsensical and not in the general good.

No.

Regressions are worse. It doesn't matter AT ALL if you think that it 
breaks ten times more devices, if it's a regression and those devices 
didn't work in the past, they simply DO NOT COUNT.

				Linus
