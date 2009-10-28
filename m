Return-Path: <linux-kernel-owner+w=401wt.eu-S1757032AbZJ1ApY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbZJ1ApY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 20:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756832AbZJ1ApX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 20:45:23 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37990 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbZJ1ApW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 20:45:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:organization:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:x-age:x-location
         :x-os:x-face:content-type:content-transfer-encoding;
        b=ouL3wyzrSOZDHjZuPXCSJScIl9GN7FtYmVhg+0Lx67ISEGIz/7bVM9jc+X1k95mvnU
         OvPlAfJGqi1reoIvEoSja8iRJHbBFSlnm3loNWxrA8bGlV+94bwSu2ZijcvDxJhelzLJ
         Jp3Bnd3BDRDMh5jgYySYMcO7pZ/6s+6gLgH18=
Message-ID: <4AE79422.8010704@gmail.com>
Date: Wed, 28 Oct 2009 01:45:22 +0100
From: =?UTF-8?B?VmVkcmFuIEZ1cmHEjQ==?= <vedran.furac@gmail.com>
Reply-To: vedran.furac@gmail.com
Organization: Home
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090701 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       rientjes@google.com
Subject: Re: [RFC][PATCH] oom_kill: avoid depends on total_vm and use real
 RSS/swap value for oom_score (Re: Memory overcommit
References: <4ADE3121.6090407@gmail.com>	<20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>	<4AE5CB4E.4090504@gmail.com>	<20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com>	<2f11576a0910262310g7aea23c0n9bfc84c900879d45@mail.gmail.com>	<20091027153429.b36866c4.minchan.kim@barrios-desktop>	<20091027153626.c5a4b5be.kamezawa.hiroyu@jp.fujitsu.com>	<28c262360910262355p3cac5c1bla4de9d42ea67fb4e@mail.gmail.com>	<20091027164526.da6a23cb.kamezawa.hiroyu@jp.fujitsu.com>	<20091027165612.4122d600.minchan.kim@barrios-desktop>	<20091027123810.GA22830@random.random> <20091028092251.8ddd1b20.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091028092251.8ddd1b20.kamezawa.hiroyu@jp.fujitsu.com>
X-Age: 25
X-Location: Lovran, Croatia
X-OS: Debian GNU/Linux
X-Face: +Lg7^E:?#]P.Y{N@61yW{aY#>fRcOE6MMqgAM|Kwk"fK!y!i4+h6&?E`Jt@uame[-SLu#*<fGtMmVfh8qo,"kJ'ql^Ni?]l|ax{fvvmD<k:2w^e(y8J2YWO`M=u17OWli}Rf^e:|w2]LulgE(:u0|}mNBZFid[YEWAC>?k:)dZv<!'a)N0b=LFDZKY!!@[%mmVO-7y`Nkj?{<C6rm9Uz$EXu;0I<PubM.Po|vlT.2&vPkJG07G.l0Ty)B/dR0k:KU<;?+WAR\f_ms2b~i"g@e}a)i1N$WLBa{vBoDs4!}k\g?lItt=|]=M{Fm@ce|^6PXq&
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:

 > Hmm, maybe
>    anon_rss + file_rss/2 + swap_usage/4 + kosaki's time accounting change
> can give us some better value. I'll consider what number is logical and
> technically correct, again.

Although my vote doesn't count, from my experience, this formula sounds
like optimal solution. Thanks, hope it gets accepted!

Regards,

Vedran


