Return-Path: <linux-kernel-owner+w=401wt.eu-S1760983AbXGDBUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760983AbXGDBUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 21:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756420AbXGDBUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 21:20:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:51807 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744AbXGDBUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 21:20:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=TwY+EvAxCqqC/pvBsXIg+ojI9OTdH910EQirUO+gy4k8dSWXO9FUQr0Ptw3ZT6RVunDU13iWKXW9jzoQIX/G2scMrxAYsVWSosL732y/nbjUbJ66K+7Xt+6M26sChAkpIuKp6s4ctdsu4onR96BZKqs4cWlQ3fq1++738EhnoUs=
Message-ID: <468AF5BB.10005@gmail.com>
Date: Wed, 04 Jul 2007 10:19:55 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Some NCQ numbers...
References: <468392CE.6010206@msgid.tls.msk.ru> <468A06A0.1020802@gmail.com> <468AB1A7.9010201@msgid.tls.msk.ru>
In-Reply-To: <468AB1A7.9010201@msgid.tls.msk.ru>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Michael Tokarev wrote:
> Well.  It looks like the results does not depend on the
> elevator.  Originally I tried with deadline, and just
> re-ran the test with noop (hence the long delay with
> the answer) - changing linux elevator changes almost
> nothing in the results - modulo some random "fluctuations".

I see.  Thanks for testing.

> In any case, NCQ - at least in this drive - just does
> not work.  Linux with its I/O elevator may help to
> speed things up a bit, but the disk does nothing in
> this area.  NCQ doesn't slow things down either - it
> just does not work.
> 
> The same's for ST3250620NS "enterprise" drives.
> 
> By the way, Seagate announced Barracuda ES 2 series
> (in range 500..1200Gb if memory serves) - maybe with
> those, NCQ will work better?

No one would know without testing.

> Or maybe it's libata which does not implement NCQ
> "properly"?  (As I shown before, with almost all
> ol'good SCSI drives TCQ helps alot - up to 2x the
> difference and more - with multiple I/O threads)

Well, what the driver does is minimal.  It just passes through all the
commands to the harddrive.  After all, NCQ/TCQ gives the harddrive more
responsibility regarding request scheduling.

-- 
tejun
