Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbZCTQOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbZCTQOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 12:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbZCTQO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 12:14:28 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:52687 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564AbZCTQO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 12:14:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gp3RBtJWmn63YUkWYMBvs76+styEivUaKqE7WI+c9EmLd8k7xsZFQc34B/XNTGK3DG
         VGaQkkbL5LnmhSb8XNU2UEYLIpqyzu7kYiG7BxoHbkfqn7wKA+aKbq7ZqKWDuLghQ4XI
         +76ksqAZJR7+A38K48Jo+OCJEL9RXisb6Si88=
MIME-Version: 1.0
In-Reply-To: <1237544033.5100.143.camel@johannes.local>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
	 <b6a2187b0903160624gb9d207dv301506e589d93ed4@mail.gmail.com>
	 <1237317742.31814.28.camel@johannes.local>
	 <b6a2187b0903181958ke11abe7tdcbc4efeb950954d@mail.gmail.com>
	 <b6a2187b0903182149x77e416ecuf73be2970173c601@mail.gmail.com>
	 <1237455534.5100.56.camel@johannes.local>
	 <b6a2187b0903192155q33510b57l9d5927538a0f4f99@mail.gmail.com>
	 <1237537967.5100.135.camel@johannes.local>
	 <b6a2187b0903200304l469e3eeet87c51b1cddb43ea8@mail.gmail.com>
	 <1237544033.5100.143.camel@johannes.local>
Date: Sat, 21 Mar 2009 00:14:24 +0800
Message-ID: <b6a2187b0903200914r23d635c9obc55b30b7cc04382@mail.gmail.com>
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

On Fri, Mar 20, 2009 at 6:13 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Can I convince you to try getting the packet dump I asked for in
> another mail?

Was digging around for the "iw" package and got distracted. I'll test it soon.

I went back to 2.6.28 and found out that I could associate as follows
(but this would not work in 2.6.29-rc8 ... should work with the
patch).

modprobe -r iwlagn
modprobe iwlagn
iwconfig wlan0 mode Managed
ifconfig wlan0 up
iwconfig wlan0 essid "xxx"
iwconfig wlan0 key restricted xxx
iwconfig wlan0 ap auto channel auto
iwlist wlan0 scan >/dev/null


Thanks,
Jeff.
