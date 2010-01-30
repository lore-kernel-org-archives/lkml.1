Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619Ab0A3Uhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab0A3Uhw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398Ab0A3Uhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:37:52 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:44358 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab0A3Uhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:37:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hOeQNdk1DUMmUGRtq2sR8DL+dZoHLElFfIADzKVJnMuaFUhoWRa8HwE95+vM4d1aaC
         lxGF9iG62RY7+aKuj0xpLSpRtUhcR/ao7kufCAzRHernhwY/0DVwg5CJ0gjLxlIJvm+U
         iKaP28iMdiMVuVPB0T9xf/LWop+xEDCR1EAL0=
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was:
 Re: [linux-pm] Memory allocations in .suspend became very unreliable)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <201001301947.10453.rjw@sisk.pl>
References: <1263549544.3112.10.camel@maxim-laptop>
	 <201001170138.37283.rjw@sisk.pl> <1264866419.27933.0.camel@maxim-laptop>
	 <201001301947.10453.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Jan 2010 22:37:43 +0200
Message-ID: <1264883863.13861.3.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-30 at 19:47 +0100, Rafael J. Wysocki wrote: 
> On Saturday 30 January 2010, Maxim Levitsky wrote:
> > On Sun, 2010-01-17 at 01:38 +0100, Rafael J. Wysocki wrote: 
> > > Hi,
> > > 
> > > I thing the snippet below is a good summary of what this is about.
> > 
> > Any progress on that?
> 
> Well, I'm waiting for you to report back:
> http://patchwork.kernel.org/patch/74740/
> 
> The patch is appended once again for convenience.

Ah, sorry!

I used the second version (with the locks) and it works for sure (~500
cycles)

However, as I discovered today, it takes the lock also for GFP_ATOMIC,
and thats why I see several backtraces in the kernel log. Anyway this
isn't important.

I forgot all about this patch, and I am compiling the kernel right away.
Will put the kernel through the hibernate loop tonight.

Best regards,
Maxim Levitsky

