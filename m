Return-Path: <linux-kernel-owner+w=401wt.eu-S1752261AbXJAMuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbXJAMuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 08:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbXJAMu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 08:50:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:17819 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbXJAMu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 08:50:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BxpuC8i0q4X4dL/rr4jaIfjJ2yoCH3zI01qZLCJ9HScsKPQ+7s9p5a/ecwf0Vemt6c+BVvQKifXgGUeuUXMhDdE+YddKCc59xh6R3t618ZDRQ7q2W1NnbK+Joiljbq78219I7fZD/jSz2ueYligDCrCXGCexmjUXvdq4fMMuiXw=
Message-ID: <b70f2f960710010550i30ae48bu31f137fe46d70611@mail.gmail.com>
Date: Mon, 1 Oct 2007 16:50:24 +0400
From: "Mikhail Kshevetskiy" <mikhail.kshevetskiy@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Fwd: x86_64 and AMD with C1E
Cc: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <b70f2f960710010546k4658aa1ay466f243ac707c989@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071001101532.025d652f@localhost>
	 <p73r6kf6uwz.fsf@bingen.suse.de>
	 <b70f2f960710010546k4658aa1ay466f243ac707c989@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

01 Oct 2007 11:33:48 +0200, Andi Kleen <andi@firstfloor.org>:
>  Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com> writes:
> >
> > The same situation can be observed for linux-2.6.22.
>
> You're saying 2.6.22/x86-64 without any patches doesn't boot out of the box
> with C1E enabled? If yes what are the exact symptoms?
>
> -Andi
>

No, it boot and work normally. The only thing i bother, is the
additional 260 timer interrupts per seconds.
Here is short result:

c1e enabled:
  -- power consumption about 23 watts
  -- there is only C1 power state enabled
  -- there are about 260 timer interrupts per seconds
tested with  x86_64(2.6.22, 2.6.23-rc8, 2.6.23-rc8-hrt1 ),
i386(2.6.21, 2.6.22, 2.6.23-rc5-hrt1)

c1e disabled:
  -- power consumption about 27 watts
  -- there are no any power state enabled (including C1)
  -- there are no additional 260 timer interrupts per seconds
tested with 2.6.23-rc6-hrt1/x86_64.

I want to reduce the power consumption of my notebook. I see the 2 possibility:
  -- remove 260 additional timer interrupts (c1e enabled case )
  -- force enable C1, C2 and C3 states  (c1e disabled case)
Do you have any idea how it can be reached?


Mikhail Kshevetskiy
