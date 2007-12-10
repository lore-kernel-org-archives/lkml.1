Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbXLJCZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbXLJCZc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbXLJCZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:25:23 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:14766 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbXLJCZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:25:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=uJ1d9WTw1g94WJ90SHXobQpsZDeiYyX/bBrPkCkAWmqINKoS0ULr2C33k4Z1Et/poTwsIYcpP6lNmt9QwUOUM19u0NtXLa+DYL+ZLsmZ5o+5vBCKzhsbiyJLDSnh9NzTiZaabFGmyVksrQedBsl4Bu0BVccLi2SRS1EBiun41hs=
Message-ID: <475CA388.9050805@gmail.com>
Date: Mon, 10 Dec 2007 11:25:12 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Andreas Mohr <andi@lisas.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
References: <fa.qQhD8aJpiTOFaZqjRYwoaG7YT1c@ifi.uio.no> <fa.yaP86AixGhz5Q7eXSu04pIQp6ho@ifi.uio.no> <fa.c3k8VKWAx4HIo9zXWbL5Ek0oSBw@ifi.uio.no> <fa.C8ACnOhs8bXB++vmugf5F34JcJg@ifi.uio.no> <fa.5o6E6S0UWnARbQPxLe30TvLQIiY@ifi.uio.no> <475AE150.9050306@shaw.ca> <20071209213642.GA27096@rhlx01.hs-esslingen.de> <20071210000429.GA3916@rhlx01.hs-esslingen.de> <20071210004959.GA23280@rhlx01.hs-esslingen.de> <475C9643.2000202@shaw.ca>
In-Reply-To: <475C9643.2000202@shaw.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> And you're quite right in your comment that we are often too quick to
> blacklist hardware instead of looking into why it really is failing.
> ACPI is one of those areas where we often just need to figure out how to
> be bug-to-bug compatibile with what Windows is doing..

In the spirit of not blacklisting without looking deep into ACPI code,
can somebody familiar with ASL take a look at comment 11 of bug 9320?

  http://bugzilla.kernel.org/show_bug.cgi?id=9320#c11

This is libata calling _GTM to find out how the BIOS configured the
device to determine cable type.

Thanks.

-- 
tejun
