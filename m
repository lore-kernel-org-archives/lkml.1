Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbXC2IAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbXC2IAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 04:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbXC2IAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 04:00:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:23024 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbXC2IAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 04:00:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K2ES5dE61++1d9sT0rYSGLYFHawY4k7QiDSgyqZde8m0QZR8D641LnKuA6J02xMFXEWLQleK0pA4eulOXCQClwprkAeHdrhv13QAFn5KaYjOlDKxbnOuIwHxMys+mcISoqSBhXT3O/qHO+EeeAj3yaHa19ilCfShRcY931u82Ok=
Message-ID: <a44ae5cd0703290100q1bb80390ke66333407bbeecfd@mail.gmail.com>
Date: Thu, 29 Mar 2007 01:00:45 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc5-mm2 -- ACPI problems (lid switch broken, always shows running from AC, plugging in AC hangs machine)
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andy Grover" <andrew.grover@intel.com>,
       "Paul Diefenbaugh" <paul.s.diefenbaugh@intel.com>, len.brown@intel.com,
       linux-acpi@vger.kernel.org
In-Reply-To: <20070328142000.ebc7712d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0703281355h13f1bd70s9eb94092bfa9c3e@mail.gmail.com>
	 <20070328142000.ebc7712d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/28/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 28 Mar 2007 13:55:54 -0700
> "Miles Lane" <miles.lane@gmail.com> wrote:
>
> > My laptop (HP dv1240us) is always showing that my laptop is plugged
> > into AC power, even when it is running off of the battery.  When I
> > plug into the AC after running on the battery, the machine immediately
> > locks up.  Also, the laptop lid button isn't working -- pressing it
> > doesn't trigger a suspend.
>
> OK, thanks.
>
> If you have time, could you please test
>
> 2.6.21-rc5 +
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/broken-out/origin.patch + ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/broken-out/git-acpi.patch
> which will allow us to eliminate any non-acpi patches.

Okay, I tested with those patches and got the same problems with the
resulting build.
I can't reproduce the hang on plugging in the AC with either
2.6.21-rc5-mm2 or the
build with the patches you sent.  The other problems are 100% reproducible.
I have some new details:

1.  Power always shows up as plugged in to AC.
2.  The lid button is non-operational for initiating a suspend.
3.  Suspending from the Gnome shutdown menu works.   Afterwards, the
lid button works for resuming from suspend.
4.  If I suspend, resume and then try to shutdown; when I see the
message "The machine will now halt" the power does not shut off.  That
is, the various buttons on my laptop stay lit up.  I am forced to
shutdown by holding down the power button for five seconds.

I hope this helps,
            Miles
