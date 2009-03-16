Return-Path: <linux-kernel-owner+w=401wt.eu-S1761215AbZCPX4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761215AbZCPX4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 19:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbZCPXzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 19:55:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:9000 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZCPXzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 19:55:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KHRqvrQ2DvVlIjcg8tZicP9S801NfEwSsNSvXCqeH2MEBNn9egmNH8JGtXkEt/jd+g
         VAdPefXHXiOkqByY8sTcTkXlo0PDZ4bUPbEf9cWLIlQ74PU7i59U/h0IdnphY1RqkXR/
         sTE2LfiQelEcle2a/9moq6e/VZRljJ2FptaEI=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0903161250080.3082@localhost.localdomain>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
	 <b6a2187b0903141958u9dae0fdk1f44b387108b99e4@mail.gmail.com>
	 <b6a2187b0903142006u546fad9eme66f9ea7b464b81f@mail.gmail.com>
	 <1237140665.24621.2.camel@johannes.local>
	 <alpine.LFD.2.00.0903151136310.3131@localhost.localdomain>
	 <1237143683.24621.7.camel@johannes.local>
	 <20090315202603.GA9077@elte.hu>
	 <b6a2187b0903160624gb9d207dv301506e589d93ed4@mail.gmail.com>
	 <alpine.LFD.2.00.0903161250080.3082@localhost.localdomain>
Date: Tue, 17 Mar 2009 07:55:49 +0800
Message-ID: <b6a2187b0903161655q15437156qc926c8db37d8ba4b@mail.gmail.com>
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 3:57 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> IOW, if you've pinpointed 71c11fb57b924c160297ccd9e1761db598d00ac2 as
> being bad, then you should go back and double-check that its parent
> (in this case 4607816f608b42a5379aca97ceed08378804c99f) is good.
> Because if it's parent is also bad, then that just means that you made
> some mistake in "git bisect".
> In this case, it really sounds like maybe you marked the parent good, even
> though you should have marked it bad.

I should have been more careful, just got thrown off during the last
few steps of the bisect. But with the bad association to the AP after
a57a59f247b651e8ed6d3eeb7e2f9d83b83134c9 (iwlwifi: remove implicit
direct scan), can someone suggest where to go from here?

Meanwhile, I'll try bisecting again.

Thanks,
Jeff.
