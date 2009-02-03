Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbZBCGJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbZBCGJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 01:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbZBCGJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 01:09:29 -0500
Received: from mx0.towertech.it ([213.215.222.73]:49531 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751277AbZBCGJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 01:09:28 -0500
Date: Tue, 3 Feb 2009 07:09:24 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ed Swierk <eswierk@aristanetworks.com>, rtc-linux@googlegroups.com,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] rtc: add rtc_systohc for ntp use
Message-ID: <20090203070924.1e02955e@i1501.lan.towertech.it>
In-Reply-To: <20090202142613.2ca84f52.akpm@linux-foundation.org>
References: <1233018262.14510.111.camel@localhost.localdomain>
	<20090202142613.2ca84f52.akpm@linux-foundation.org>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Feb 2009 14:26:13 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > No attempt is made to compensate for the 500-ms delay imposed when
> > setting a cmos rtc chip.  If you actually have a cmos rtc you can stick
> > with the existing code, but at some point it would be nice to unify
> > these.
> 
> I don't get this.  Do we not currently update the cmos clock in
> response to NTP controls?  Does the patch now alter this policy, by now
> updating the RTC?

 Hi Andrew, please do not apply yet. It's still experimental.
 The clock is not currently updated in ntp mode and my original patch
 plus Ed's work is meant to fix this.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

