Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbZJZQQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbZJZQQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZJZQQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:16:13 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:56953 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbZJZQQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:organization:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:x-age:x-location
         :x-os:x-face:content-type:content-transfer-encoding;
        b=py++F3QgMCdOxJfWRVjXLd/tYtQWUpHk18/an8N0Yb6aC07pK4OVroK30+o+YtZpcl
         CG3+T/MICtzuw7OyrdI9GTRo2+nMw7l8NUVvRgYidl1ZE/Y7JeEfXsRXWsOGtYnpbWwV
         7UPb9djC/FVUPsjVkVks3LXct8oGWQ4D5jSMU=
Message-ID: <4AE5CB4E.4090504@gmail.com>
Date: Mon, 26 Oct 2009 17:16:14 +0100
From: =?UTF-8?B?VmVkcmFuIEZ1cmHEjQ==?= <vedran.furac@gmail.com>
Reply-To: vedran.furac@gmail.com
Organization: Home
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090701 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Memory overcommit
References: <hav57c$rso$1@ger.gmane.org>	<20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com>	<hb2cfu$r08$2@ger.gmane.org>	<20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com>	<4ADE3121.6090407@gmail.com> <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>
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

> Can I make more questions ?

Sure

>  - What's cpu ?

vendor_id       : AuthenticAMD


cpu family      : 16


model           : 4


model name      : AMD Phenom(tm) II X3 720 Processor


stepping        : 2


cpu MHz         : 3314.812


cache size      : 512 KB


>  - How much memory ?
>  - Do you have swap ?

           total       used       free     shared    buffers     cached
Mem:        3459       1452       2007          0         65        622
-/+ buffers/cache:      764       2695
Swap:          0          0          0

So, no swap. Don't need it.

>  - What's the latest kernel version you tested?

2.6.30-2-amd64 #1 SMP (on Debian)

>  - Could you show me /var/log/dmesg and /var/log/messages at OOM ?

It was catastrophe. :) X crashed (or killed) with all the programs, but
my little program was alive for 20 minutes (see timestamps). And for
that time computer was completely unusable. Couldn't even get the
console via ssh. Rally embarrassing for a modern OS to get destroyed by
a 5 lines of C run as an ordinary user. Luckily screen was still alive,
oomk usually kills it also. See for yourself:

dmesg: http://pastebin.com/f3f83738a
messages: http://pastebin.com/f2091110a

(CCing to lklm again... I just want people to see the logs.)

Regards,

Vedran

