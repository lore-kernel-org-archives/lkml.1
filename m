Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445Ab0A2AZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab0A2AZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 19:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335Ab0A2AZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 19:25:25 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:42801 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab0A2AZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 19:25:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:newsgroups:to
         :cc:subject:references:in-reply-to:x-enigmail-version:x-age
         :x-location:x-os:x-face:content-type:content-transfer-encoding;
        b=Y6WHpVoGjhOmCEbrOe8nynBFXXYyryV9+vHklNBaxlWqasNz8CK7NGn6fzVvuHCplP
         pmFCi1crOS1iBccgsX4Dr8QTNIgwkaITQ7opU+1pie7ykTlv2jUuGRrwpvHmgdQFg606
         NGq1F3iBp1qJXEJWcQneE4cN7Xu107QQ9CUR4=
Message-ID: <4B622AEE.3080906@gmail.com>
Date: Fri, 29 Jan 2010 01:25:18 +0100
From: =?UTF-8?B?VmVkcmFuIEZ1cmHEjQ==?= <vedran.furac@gmail.com>
Reply-To: vedran.furac@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20091109 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, rientjes@google.com,
       minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>	<20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com>	<20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com>	<20100126151202.75bd9347.akpm@linux-foundation.org>	<20100127085355.f5306e78.kamezawa.hiroyu@jp.fujitsu.com>	<20100126161952.ee267d1c.akpm@linux-foundation.org>	<20100127095812.d7493a8f.kamezawa.hiroyu@jp.fujitsu.com> <20100128001636.2026a6bc@lxorguk.ukuu.org.uk>
In-Reply-To: <20100128001636.2026a6bc@lxorguk.ukuu.org.uk>
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

Alan Cox wrote:

> Am I missing something fundamental here ?

Yes, the fact linux mm currently sucks. How else would you explain
possibility of killing random (often root owned) processes using a 5
lines program started by an ordinary user? Killed process could be an
apache web server or X server on a desktop. I demonstrated this flaw few
months ago here and only Kame tried to find a way to fix it but
encountered noncooperation.

I don't know what to say, really. Sad... Actually funny, when you know
that competition OS, often ridiculed by linux users, doesn't suffer any
consequences when that same 5 line program is run.

Regards,
Vedran


-- 
http://vedranf.net | a8e7a7783ca0d460fee090cc584adc12
