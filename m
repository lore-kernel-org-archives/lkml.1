Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbZCTE4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbZCTE4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 00:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbZCTEzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 00:55:49 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:53810 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZCTEzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 00:55:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HC/Ghyyanyv3QUl5JjrsFbecS+gPwH/D1glkY2T3icA5JAdL5+3jzScj2CteyVs8pu
         3hFpZvT1Wd0p+pCkeoZN87taAfk3kGwbRZYrEX65rQCP7VVhHFm3vwmQOkSEWtUOlEEZ
         s1RBw4pM+Oj/KptCEtJdhMpkNaO0uGIouYfv8=
MIME-Version: 1.0
In-Reply-To: <1237455534.5100.56.camel@johannes.local>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
	 <1237140665.24621.2.camel@johannes.local>
	 <alpine.LFD.2.00.0903151136310.3131@localhost.localdomain>
	 <1237143683.24621.7.camel@johannes.local>
	 <20090315202603.GA9077@elte.hu>
	 <b6a2187b0903160624gb9d207dv301506e589d93ed4@mail.gmail.com>
	 <1237317742.31814.28.camel@johannes.local>
	 <b6a2187b0903181958ke11abe7tdcbc4efeb950954d@mail.gmail.com>
	 <b6a2187b0903182149x77e416ecuf73be2970173c601@mail.gmail.com>
	 <1237455534.5100.56.camel@johannes.local>
Date: Fri, 20 Mar 2009 12:55:44 +0800
Message-ID: <b6a2187b0903192155q33510b57l9d5927538a0f4f99@mail.gmail.com>
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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

On Thu, Mar 19, 2009 at 5:38 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-03-19 at 12:49 +0800, Jeff Chua wrote:
>
>> Ignore the above loop thing. The cause seems to be this one instead.
>>
>>
>> # this needs patch to work ...
>> iwconfig wlan0 mode Managed
>> ifconfig wlan0 up
>> iwconfig wlan0 essid xxx
>> iwconfig wlan0 key restricted xxx
>> iwconfig wlan0 ap auto channel auto
>
> If you swap the key and essid lines, it will probably always work. But
> I've yet to analyse your data to see why it doesn't in the other case.

Doesn't. Taking away "hiwconfig wlan0 ap auto channel auto" makes it works.

Thanks,
Jeff.
