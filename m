Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617Ab0ABI0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab0ABI0f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 03:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037Ab0ABI0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 03:26:34 -0500
Received: from www84.your-server.de ([213.133.104.84]:60355 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab0ABI0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 03:26:33 -0500
Subject: Re: [PATCH] proc: revert to show stack information in 
 /proc/{pid}/status
From: Stefani Seibold <stefani@seibold.net>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <2f11576a1001012153qec2ea0eo7a2762386ed22273@mail.gmail.com>
References: <20091231231051.1A1B.A69D9226@jp.fujitsu.com>
	 <1262274494.14143.7.camel@wall-e>
	 <20100101155630.1A1E.A69D9226@jp.fujitsu.com>
	 <1262358616.11460.18.camel@wall-e> <20100101220529.GL4620@const>
	 <1262384490.16706.4.camel@wall-e>
	 <2f11576a1001012153qec2ea0eo7a2762386ed22273@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 02 Jan 2010 09:26:16 +0100
Message-ID: <1262420776.18097.3.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 02.01.2010, 14:53 +0900 schrieb KOSAKI Motohiro:
> 2010/1/2 Stefani Seibold <stefani@seibold.net>:
> > Am Freitag, den 01.01.2010, 23:05 +0100 schrieb Samuel Thibault:
> >> Stefani Seibold, le Fri 01 Jan 2010 16:10:16 +0100, a écrit :
> >> > But ps is not a performance critical application nor a cat
> >> > /proc/*/status!
> >>
> >> Errr, maybe not so much as some other operations, but a lot of tools use
> >> them, so it's really worth considering it.
> >
> > Right. And i am still trying to find some optimization. Stay tuned.
> 
> I can understand you feel sad. but don't worry. reverting is very usual event
> on kernel development. You can retry anytime if you make optimized code.

I had analyzed the problem and there is only one solution. Create a new
proc/<pid>/stack_usage entry, which was my first idea. This has absolut
now side effects.

I will write a patch and post it in the next days.

Stefani


