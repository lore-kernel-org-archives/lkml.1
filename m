Return-Path: <linux-kernel-owner+w=401wt.eu-S1759030AbYFXI2C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030AbYFXI2C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:28:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759450AbYFXI1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:27:35 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:42755 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441AbYFXI1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:27:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=O/GPa24SQKQLOPAEuaWgWcE2s0ViuwppncZYQWkh2w9FNBdY80wesucxCA9l9Yum81
         BXwb+mK8DUP8kA7z+TV5kI6qJAQtJVulo9tRxV/8UxcXHLY0oF3gO/ZHdtU/GikcP5yG
         kAsndE6u+U+GT8URFb07ds1GicPQdaeIGAkD4=
Message-ID: <cfd18e0f0806240127y105d759aye6b60715e74b823@mail.gmail.com>
Date: Tue, 24 Jun 2008 10:27:28 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: nanosleep() uses CLOCK_MONOTONIC, should be CLOCK_REALTIME?
Cc: "Roman Zippel" <zippel@linux-m68k.org>,
       "Michael Kerrisk" <mtk.manpages@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "john stultz" <johnstul@us.ibm.com>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <e2e108260806240101u30f85da8w7404e52f189f8d9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485E00CD.9060503@gmail.com>
	 <e2e108260806230134g48f5ac63mb93256e08c57b4f7@mail.gmail.com>
	 <cfd18e0f0806230248g3a2ab795s63de2b96538ebdd0@mail.gmail.com>
	 <Pine.LNX.4.64.0806231438130.6791@localhost.localdomain>
	 <cfd18e0f0806232239w78546747p8fb899f614c89496@mail.gmail.com>
	 <e2e108260806240101u30f85da8w7404e52f189f8d9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 10:01 AM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> On Tue, Jun 24, 2008 at 7:39 AM, Michael Kerrisk
> <mtk.manpages@googlemail.com> wrote:
>> I'll add some text (not quite sure what yet) in the nanosleep() man
>> page on this point.
>
> You could e.g. mention that nanosleep() is neither affected by the
> settimeofday() system call

Thanks.  Yes, that follows fairly naturally from the statement about
clock_settime().

> nor by adjtimex() (this last one is used by
> ntpd).

That surprised me a little.  So gradual adjustments to the time made
by adjtime() / adjtimex() really don't affect nanosleep()?

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
