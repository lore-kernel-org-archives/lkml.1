Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbZKBTzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbZKBTzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756495AbZKBTzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:55:54 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39713 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbZKBTzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:55:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:organization:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:x-age:x-location
         :x-os:x-face:content-type:content-transfer-encoding;
        b=uqTlwBasFT5YOkjPbR5pCnumdA9vrAizCMBlGNJvUEKqK1y9Kp92YzItyqq5XngaDb
         iDAxaT2s//kMMlCQsG8x5k5GRnrxmBImZ2avAI/9OHRrvYywvRHO62CUr/RDpU4LGWhs
         9Wa+ItbLaTvjCtaidncCa9PUHxe+UiR2LK3DU=
Message-ID: <4AEF394A.4050102@gmail.com>
Date: Mon, 02 Nov 2009 20:55:54 +0100
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
References: <20091028175846.49a1d29c.kamezawa.hiroyu@jp.fujitsu.com>	 <alpine.DEB.2.00.0910280206430.7122@chino.kir.corp.google.com>	 <abbed627532b26d8d96990e2f95c02fc.squirrel@webmail-b.css.fujitsu.com>	 <20091029100042.973328d3.kamezawa.hiroyu@jp.fujitsu.com>	 <alpine.DEB.2.00.0910290125390.11476@chino.kir.corp.google.com>	 <2f11576a0911010529t688ed152qbb72c87c85869c45@mail.gmail.com>	 <alpine.DEB.2.00.0911020237440.13146@chino.kir.corp.google.com> <2f11576a0911020435n103538d0p9d2afed4d39b4726@mail.gmail.com>
In-Reply-To: <2f11576a0911020435n103538d0p9d2afed4d39b4726@mail.gmail.com>
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

> Oh, I'm sorry. I mesured with rss patch.
> Then, I haven't understand what makes Xorg bad score.
> 
> Hmm...
> Vedran,  Can you please post following command result?
> 
> # cat /proc/`pidof Xorg`/smaps
> 
> I hope to undestand the issue clearly before modify any code.


No problem:

http://pastebin.com/d66972025 (long)

Xorg is from debian unstable.

Regards,

Vedran


