Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYKJHN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYKJHN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 02:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYKJHNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 02:13:19 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:58314 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbYKJHNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 02:13:18 -0500
From: Paul Collins <paul@burly.ondioline.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       James Cloos <cloos@jhcloos.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #11875] radeonfb lockup in .28-rc (bisected)
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	<wnN9HICUAgP.A._d.f5zFJB@chimera> <1226295985.7731.7.camel@pasglop>
Date: Mon, 10 Nov 2008 20:13:17 +1300
In-Reply-To: <1226295985.7731.7.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Mon, 10 Nov 2008 16:46:25 +1100")
Message-ID: <87abc8rr3m.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> On Sun, 2008-11-09 at 18:59 +0100, Rafael J. Wysocki wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>> 
>> The following bug entry is on the current list of known regressions
>> from 2.6.27.  Please verify if it still should be listed and let me know
>> (either way).
>
> Allright, so I finally managed to find a machine to reproduce it and
> I have a patch that fixes it here. I'm basically implementing the same
> thing as X which is to ensure the bitmap is padded to 32 pixels.

Works great here (as you might expect).

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
