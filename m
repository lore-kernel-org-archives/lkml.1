Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbZJDMoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbZJDMoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 08:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZJDMoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 08:44:00 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:47369 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbZJDMn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 08:43:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qAK9ZgkPkbggtuvc3E54QJp7zt1by9xCq4hpe5ME5gNuc9H4KME7TZ18rR4Xnnjnk8
         M3gm7dYC8SlItQoG1yIoFrAIQNr5wDIQu2AhI9ESz/R/Knw75yU0tYa0WA87i3uymBLC
         UdRyBGn/xrcXpE69tfDDXf6s1rc3VL778Sdjw=
Date: Sun, 4 Oct 2009 16:43:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14270] Cannot boot on a PIII Celeron
Message-ID: <20091004124320.GA6781@lenovo>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.7sH.xMTxKB@chimera> <aa79d98a0910020130p4d3c5b5fh9597ea435db7f872@mail.gmail.com> <4AC5C42E.9070909@msgid.tls.msk.ru> <4AC5D810.3080307@msgid.tls.msk.ru> <aa79d98a0910020355r31b37ea0v1fef7286f7a71508@mail.gmail.com> <4AC5DCFD.4010107@msgid.tls.msk.ru> <4AC891B4.20407@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC891B4.20407@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Michael Tokarev - Sun, Oct 04, 2009 at 04:14:44PM +0400]
...
>>
>> I switched to BZIP2, it booted fine.  I switched back to LZMA -
>> and that one now boots too.  Original bzImage, which were built
>> by the same compiler from the same source using the same
>> options reboots.
>>
>> So um... I'm now trying to reproduce it ;)
>
> I performed about 20 kernel recompiles, and finally have some "statistics".
> The problem is almost reproduceable, in a sense that I was able to get 6
> more cases behaving the same way (rebooting right at early boot on a cel).
> And all 3 "non-working" cases were with ccache.  Ie, about half out of ~25
> compiles done with ccache, and 7 of the resulting kernels are buggy.  No
> single failure without ccache so far.
>
> Maybe it's some stale .o file cached by ccache (and it indeed looks like
> that) -- I didn't try to remove the cache yet (but my guess is that I
> wont be able to reproduce the issue with clean cache anymore).
>
> What puzzles me most is the "failure mode".  The difference between the
> two processors is minimal.  Having a corrupt .o file and almost-working
> kernel is almost impossible by its own.  And hitting this difference with
> a corrupt .o file is.. unbelievable.
>
> So I'm declaring it's a false alarm for now, and closing the bug.

ok, thanks for hard work on this Michael!

>
> /mjt
>
	-- Cyrill
