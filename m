Return-Path: <linux-kernel-owner+w=401wt.eu-S1752738AbZEYRNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbZEYRNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 13:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbZEYRNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 13:13:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:36289 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751940AbZEYRNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 13:13:07 -0400
X-Authenticated: #10801262
X-Provags-ID: V01U2FsdGVkX18H7m1paVcHGm9hazv6wu1vWc60hrJBOTK/yYUsaw
	qJzKfdaaR4Pe1l
Date: Mon, 25 May 2009 19:13:05 +0200
From: Richard Atterer <richard@2009.atterer.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13371] s2disk hangs with kernel 2.6.29 and later, SATA,
	Gigabyte EG45M-DS2H
Message-ID: <20090525171305.GA5855@arbonne.lan>
Mail-Followup-To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <200905251448.40907.bzolnier@gmail.com> <20090525134522.GA7805@arbonne.lan> <200905251630.21781.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200905251630.21781.bzolnier@gmail.com>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 04:30:21PM +0200, Bartlomiej Zolnierkiewicz wrote:
> Hmm, we added ACPI NVS memory handling there and some machines seem
> to have trouble with it.  I think it would be worth to check it first.
> 
> Richard, could you try s2disk on some recent 2.6.30-rc kernel while
> booting using "acpi_sleep=s4_nonvs"?

I just tried that with 2.6.30-rc7, unfortunately it doesn't make any 
difference.

It turns out that if I wait long enough (just over 1 minute) both during 
suspend and resume, I *am* able to suspend and resume the machine. I have 
to manually turn it off or reset it though.

Another possibly interesting observation: My DVD writer apparently gets 
reset before the 1-minute hang and my USB hub after the hang.

Cheers,

  Richard

-- 
  __   _
  |_) /|  Richard Atterer
  | \/¯|  http://atterer.net
  ¯ '` ¯
