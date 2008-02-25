Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYBYDMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYBYDMh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 22:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbYBYDM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 22:12:28 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55941 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYBYDM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 22:12:27 -0500
Date: Mon, 25 Feb 2008 12:10:43 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Paul Jackson <pj@sgi.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: Tiny cpusets -- cpusets for small systems?
Cc: kosaki.motohiro@jp.fujitsu.com, "Max Krasnyanskiy" <maxk@qualcomm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andreas Dilger <adilger@sun.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Spang <daniel.spang@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jon Masters <jonathan@jonmasters.org>,
       Marcelo Tosatti <marcelo@kvack.org>, Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080223060911.e1d13cc1.pj@sgi.com>
References: <20080223060911.e1d13cc1.pj@sgi.com>
Message-Id: <20080225120050.AE81.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pual

> Looking at some IA64 sn2 config builds I have laying about, I see the
> following text sizes for a couple of versions, showing the growth of
> the cpuset/cgroup apparatus over time:
> 
> 	25933	2.6.18-rc3-mm1/kernel/cpuset.o (Aug 2006)
> vs.
> 	37823	2.6.25-rc2-mm1/kernel/cgroup.o (Feb 2008)
> 	19558	2.6.25-rc2-mm1/kernel/cpuset.o
> 
> So the total has grown from 25933 to 57381 text bytes (note that
> this is IA64 arch; most arch's will have proportionately smaller
> text sizes.)

hm, interesting.
but unfortunately the cpuset have more than depend.(i.e. CONFIG_SMP)

To more bad thing, some embedded cpu have poor or no atomic instruction
support.
at that, turn on CONFIG_SMP become large performace regression ;)


I am not already embedded engineer.
thus, I might have made a mistake.
(BTW: I am large server engineer now)

but no thinking dependency is wrong, may be.


Pavel, what do you think it?

- kosaki


