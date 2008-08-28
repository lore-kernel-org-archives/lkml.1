Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbYH1Nml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbYH1Nml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 09:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYH1Nm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 09:42:29 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:37408 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbYH1Nm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 09:42:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gPOj9j5kJTbkL4/bKOP/9f8JzMIutKYeOJJLYmZ5hNzTJmkGTPhcq2G0BVbKo3HbQa
         rEcls1hE2Lam+1vpJGPS25gPNy39WGTVgUynjvOPxPziCn4MyWyd+rVCLKnDRrjVjVG/
         PMLerN4QOOGRuNc/G4ajY1w8iqtk93Fceoqtw=
Message-ID: <19f34abd0808280642j529eab2ct17722644d1550ad9@mail.gmail.com>
Date: Thu, 28 Aug 2008 15:42:26 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Daniel J Blueman" <daniel.blueman@gmail.com>
Subject: Re: SLUB/debugobjects locking (Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26)
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <6278d2220808261514p2661251aw914215652c547125@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808251244v439e78b1hbb24f77c637559c3@mail.gmail.com>
	 <6278d2220808261514p2661251aw914215652c547125@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 12:14 AM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> On Mon, Aug 25, 2008 at 8:44 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> I tried your suggestion of promoting the lock to irq-safe, and it
>> fixed the warning for me (didn't get or look for deadlocks yet, but it
>> seems likely that it is caused by the same thing?), the patch is
>> attached for reference.
>>
>> I also don't know if this is the best fix, but I also don't have any
>> other (better) suggestions.
>>
>> Others are welcome to pick it up from here...
>
> The solution looks like is needs to get the lock ordering correct
> w.r.t. SLUB, as we get this, alas:
>
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.27-rc4-229c-debug #1

Hm. Is this with my first patch + the one in the e-mail you replied
to? It was intended to be a delta patch on top of my first one.

That would be the one in

    http://marc.info/?l=linux-kernel&m=121946972307110&w=4

plus the one in

    http://marc.info/?l=linux-kernel&m=121969394110327&w=1

Thanks for testing and sorry for the confusion. (Maybe I just confused
myself. Please let me know either way.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
