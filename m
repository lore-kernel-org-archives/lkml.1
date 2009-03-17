Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbZCQRV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbZCQRV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 13:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbZCQRVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 13:21:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:46240 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbZCQRVN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 13:21:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T5dkfd/MmA8E5yhMMljzXvHE0LhCSUstm1W0pOovZa1KvXgIrPlnJECoDfYC5sSvya
         4m8qq5EjjT1b+m5dNLRvzWqk/ZY7qPRVXYnyUZtZVeA1bEyMDXu/p3snA5NNqGqtXmRt
         jqARVUX1dOxYIAmxTW45kZ+ERflP+2wOJksyQ=
MIME-Version: 1.0
In-Reply-To: <1237276212.18086.11.camel@johannes.local>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
	 <b6a2187b0903142006u546fad9eme66f9ea7b464b81f@mail.gmail.com>
	 <1237140665.24621.2.camel@johannes.local>
	 <alpine.LFD.2.00.0903151136310.3131@localhost.localdomain>
	 <1237143683.24621.7.camel@johannes.local>
	 <20090315202603.GA9077@elte.hu>
	 <b6a2187b0903160624gb9d207dv301506e589d93ed4@mail.gmail.com>
	 <alpine.LFD.2.00.0903161250080.3082@localhost.localdomain>
	 <b6a2187b0903161655q15437156qc926c8db37d8ba4b@mail.gmail.com>
	 <1237276212.18086.11.camel@johannes.local>
Date: Wed, 18 Mar 2009 01:21:11 +0800
Message-ID: <b6a2187b0903171021t692bb563mea3a8529f9672504@mail.gmail.com>
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 3:50 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> If you don't have a second device to monitor, you can also create a
> monitor interface as such:
>        iw dev wlan0 interface add moni0 type monitor flags none
>
> and run tcpdump on the resulting 'moni0' interface while you try to
> associate etc. Write the packets to files and send them to me.
>
> Due to this implicit scan modification in the driver that I removed,
> however, I won't see scans in that file, so it won't be all that useful,
> a capture made on a second device would be much better.

Ok, I'll try this out later. Got good news to share. I've applied
John's patches and just need to modified net/mac80211/wext.c slightly
since len and ssid are not defined, and function arguments are
different. I'm checking my tree again ... my seems different from his.

Thanks,
Jeff.
