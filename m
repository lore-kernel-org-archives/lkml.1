Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbYFXGf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbYFXGf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 02:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYFXGfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 02:35:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:40726 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYFXGfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 02:35:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=EULSLhAl0Blhp53cqBuJSr8cC/8wE/Glx+iVcEwCT8wug/8zOeKq/2ee4fVG3Q3wEw
         j8spcBuvx9TCeNxBYcwF2pmimkMiAQVjvD0cTzHlgUy9LKz/StckNu7fDCicBJlL0rzM
         tO5oG1MjNPWH4U1CAkkSOZH5rb9KUpuOE2gLQ=
Message-ID: <cfd18e0f0806232335p3e05d690o5a5cef8c9626fae7@mail.gmail.com>
Date: Tue, 24 Jun 2008 08:35:11 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
Subject: When did High-Resolution Timers hit mainline?
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "john stultz" <johnstul@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Thomas,

I want to update some timer and sleep man pages to reflect the arrival
of high-resolution timers.  However, it's not quite clear to me when
HRTs properly arrived in mainline.  Was it 2.6.21?  And at that point,
was the resolution for all timer and sleep calls based on HRTs, so
that they all became more accurate?  (Or was it the case that various
system calls switched over to HRTs in different later kernel
versions?)  Specifically, I'm thinking of the following system calls

nanosleep()
clock_nanosleep()
setitimer()
timer_create()/timer_settime()

Was it the case that pre 2.6.21 (or whatever) these were all
jiffy-based in their accuracy, and then post 2.6.21, they were all HRT
based (if CONFIG_HIGH_RES_TIMERS is enabled)?

Cheers,

Michael
-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
