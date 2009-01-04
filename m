Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZADDFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZADDFY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 22:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZADDFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 22:05:07 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:53408
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZADDFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 22:05:06 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Sat, 3 Jan 2009 21:05:00 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Matthieu CASTET <matthieu.castet@parrot.com>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <200901031346.01325.rob@landley.net> <4960068A.3040109@shaw.ca>
In-Reply-To: <4960068A.3040109@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901032105.00779.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009 18:44:58 Robert Hancock wrote:
> Rob Landley wrote:
> > For the record, the reason I can't just pregenerate all these suckers on
> > a system that's got an arbitrary precision calculator (ala dc) and then
> > just ship the resulting header files (more or less the what the first
> > version of that first patch did) is that some architectures (arm omap and
> > and arm at91) allow you to enter arbitrary HZ values in kconfig.  (Their
> > help text says that in many cases values that aren't powers of two won't
> > work, but nothing enforces this.)  So if we didn't have the capability to
> > dynamically generate these, you could enter a .config value that would
> > break the build.
>
> Is there a good reason that these archs allow you enter arbitrary HZ
> values?

Not that I've noticed, no.  But you should ask Thomas Gleixner about that 
about that, I'm not a domain expert...

> The use case for using custom HZ values at all nowadays seems
> fairly low now that dynticks is around (if that arch supports it
> anyway), let alone being able to specify wierd obscure values for it.

And high performance event timers.  A kernel can have more than one time 
source these days...

Rob
