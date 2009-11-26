Return-Path: <linux-kernel-owner+w=401wt.eu-S1759959AbZKZAKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959AbZKZAKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 19:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbZKZAKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 19:10:11 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:60762 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbZKZAKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 19:10:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:organization:user-agent
         :mime-version:to:cc:subject:references:in-reply-to
         :x-enigmail-version:x-age:x-location:x-os:x-face:content-type
         :content-transfer-encoding;
        b=L934s3dlHiBpao1L0kuNcd2FqWXKl2+vmidVVVPEX72BYlSYNHXYRjed+ECwjZS0Ph
         oniaHMt1WSIE282Qawf49RySJIGyuuX+1Oet0VGlO/IMw7k5jwZbalWgjsFAD5q++8ma
         FqrL7d5Pgwjl+d6nAY4D7soyiiTiey84r5lEo=
Message-ID: <4B0DC764.8040205@gmail.com>
Date: Thu, 26 Nov 2009 01:10:12 +0100
From: =?UTF-8?B?VmVkcmFuIEZ1cmHEjQ==?= <vedran.furac@gmail.com>
Reply-To: vedran.furac@gmail.com
Organization: Home
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20091109 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] oom_kill: use rss value instead of vm size for badness
References: <20091028175846.49a1d29c.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910280206430.7122@chino.kir.corp.google.com> <abbed627532b26d8d96990e2f95c02fc.squirrel@webmail-b.css.fujitsu.com> <20091029100042.973328d3.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910290125390.11476@chino.kir.corp.google.com> <20091125124433.GB27615@random.random>
In-Reply-To: <20091125124433.GB27615@random.random>
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

Andrea Arcangeli wrote:

> Hello,

Hi all!

> lengthy discussion on something I think is quite obviously better and
> I tried to change a couple of years back already (rss instead of
> total_vm).

Now that 2.6.32 is almost out, is it possible to get OOMK fixed in
2.6.33 so that I could turn overcommit on (overcommit_memory=0) again
without fear of loosing my work?

Regards,

Vedran


-- 
http://vedranf.net | a8e7a7783ca0d460fee090cc584adc12
