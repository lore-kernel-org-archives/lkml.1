Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbZKGTWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbZKGTWB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 14:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbZKGTWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 14:22:00 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:58388 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbZKGTV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 14:21:59 -0500
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Nov 2009 14:21:59 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:organization:user-agent
         :mime-version:to:cc:subject:references:in-reply-to
         :x-enigmail-version:x-age:x-location:x-os:x-face:content-type
         :content-transfer-encoding;
        b=G3RKPq6YYBdaXhsQsyFfzD4H2QKpEzjyTxOC+5HcQl7RXXqCetgibgKWJfxzWD3nj2
         wLs5nBMbbMCtZj+aDw0e4w/9l8+bNtxMrDgo5O6J/3AZQnadGyj2AFmbgkef2ZQ3nQeN
         lSgq/XFcUhkmStvXOmWu1lHLs9Z6PRpREN0lU=
Message-ID: <4AF5C779.7000909@gmail.com>
Date: Sat, 07 Nov 2009 20:16:09 +0100
From: =?UTF-8?B?VmVkcmFuIEZ1cmHEjQ==?= <vedran.furac@gmail.com>
Reply-To: vedran.furac@gmail.com
Organization: Home
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090701 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] oom_kill: use rss value instead of vm size for badness
References: <2f11576a0911020435n103538d0p9d2afed4d39b4726@mail.gmail.com> <4AEF394A.4050102@gmail.com> <20091104002903.0B4D.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091104002903.0B4D.A69D9226@jp.fujitsu.com>
X-Enigmail-Version: 0.95.7
X-Age: 25
X-Location: Lovran, Croatia
X-OS: Debian GNU/Linux
X-Face: +Lg7^E:?#]P.Y{N@61yW{aY#>fRcOE6MMqgAM|Kwk"fK!y!i4+h6&?E`Jt@uame[-SLu#*<fGtMmVfh8qo,"kJ'ql^Ni?]l|ax{fvvmD<k:2w^e(y8J2YWO`M=u17OWli}Rf^e:|w2]LulgE(:u0|}mNBZFid[YEWAC>?k:)dZv<!'a)N0b=LFDZKY!!@[%mmVO-7y`Nkj?{<C6rm9Uz$EXu;0I<PubM.Po|vlT.2&vPkJG07G.l0Ty)B/dR0k:KU<;?+WAR\f_ms2b~i"g@e}a)i1N$WLBa{vBoDs4!}k\g?lItt=|]=M{Fm@ce|^6PXq&
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

> Your Xorg have pretty large heap. I'm not sure why it happen. (ATI
> video card issue?)

It is ATI (fglrx), but I don't know if it is driver's issue or not. I
have a lot of apps running, firefox with high number of tabs and so on.
It adds up probably.

> Unfortunatelly, It is showed as normal large heap from kernel. then, 
> I doubt kernel can distinguish X from other process. Probably oom-adj
> is most reasonable option....
>
> -------------------------------------------------
> [heap]
> Size:             433812 kB
> Rss:              433304 kB
> Pss:              433304 kB
> Shared_Clean:          0 kB
> Shared_Dirty:          0 kB
> Private_Clean:       280 kB
> Private_Dirty:    433024 kB
> Referenced:       415656 kB
> Swap:                  0 kB
> KernelPageSize:        4 kB
> MMUPageSize:           4 kB



