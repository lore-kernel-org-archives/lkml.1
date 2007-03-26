Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbXCZKgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbXCZKgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbXCZKgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:36:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:5521 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbXCZKgb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:36:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NHDMUUjr7lZFXw7hmBaIdC7gNxk/ziiG6JD0RsNDJwZAGWUVfumJ7kS/JSBQV3dpOviRgvvzqpyQL17HnzATCm0zkb+W/NJHbcldF3puGLsPQVU4TO5IuqF435x9EaOaCRvx2BsYMzlRMWe1HCpblZJp8PFhJFj4ZiMfkfXKDhI=
Message-ID: <87d3b2040703260336w47dafb9aoe00194a8de8dc05d@mail.gmail.com>
Date: Mon, 26 Mar 2007 12:36:30 +0200
From: "Frederic Riss" <frederic.riss@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
Cc: "Adrian Bunk" <bunk@stusta.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       "Tino Keitel" <tino.keitel@gmx.de>,
       "Bob Moore" <robert.moore@intel.com>, lenb@kernel.org
In-Reply-To: <1174900493.4182.14.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185022.GQ752@stusta.de>
	 <1174858456.5550.32.camel@funkylaptop>
	 <1174891519.5550.36.camel@funkylaptop>
	 <1174900493.4182.14.camel@chaos>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/26, Thomas Gleixner <tglx@linutronix.de>:
> On Mon, 2007-03-26 at 08:45 +0200, Frédéric RISS wrote:
> > Additional data point: I just tried with -rc5 and the issue is still
> > present. The config I used for this test defines neither NO_HZ nor
> > HIGH_RES_TIMERS.
>
> Do you have CONFIG_HPET_TIMER enabled and does the box have one ?
> If yes, can you please turn it off and retry ?

IIRC the box has a HPET and it gets used. I'll test and confirm when I
get home tonight.

Thanks,
Fred
