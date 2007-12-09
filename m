Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbXLISmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbXLISmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 13:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbXLISlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 13:41:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45880 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbXLISlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 13:41:52 -0500
Date: Sun, 9 Dec 2007 10:41:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
In-Reply-To: <20071209134217.7ff02dd2@the-village.bc.nu>
Message-ID: <alpine.LFD.0.9999.0712091036380.12046@woody.linux-foundation.org>
References: <200712080340.49546.rjw@sisk.pl> <20071208015227.3a1c7fae.akpm@linux-foundation.org> <475B9270.6070902@gmail.com> <20071209134217.7ff02dd2@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 9 Dec 2007, Alan Cox wrote:
> 
> Great, make everyone else wait another three months for a working CD
> drive. The one off regression appears far less harmful than a revert.

Btw, Alan, that "math" is total and utter BULLSH*T, and you should know 
that.

"The one off regression" is likely the tip of an iceberg. If something 
regresses for one person, for that one person who tested and noticed and 
made a bug-report, there's probably a thousand people who haven't even 
tested the development kernel, or who had problems and just went back to 
the previous version.

In contrast, reverting something will be guaranteed to not have those 
kinds of issues, since the only people who could notice are people for who 
it never worked in the first place. There's no "silent mass of people" 
that can be affected.

This is why regressions are so important. They don't trump _everything_, 
but basically ignoring and letting them slide is *much* more painful than 
just reverting it.

The biggest reason to ignore a regression is if nobody can even figure 
out where it came from, or reverting simply isn't an option for some 
really deep and fundamental issue. That doesn't seem to be the case here. 

So we should revert unless there is some known acceptable real fix.

		Linus

