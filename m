Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbZI2FoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbZI2FoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 01:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbZI2FoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 01:44:09 -0400
Received: from mail-pz0-f198.google.com ([209.85.222.198]:38482 "EHLO
	mail-pz0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbZI2FoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 01:44:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xkiGOMfsP5/Cx77xP+8OY5tid27c8KOfYqGQNalBG2Xwq7ZBAFOzZxdSHT/lHPwKfr
         Un8dNt5LZYc4FeuOvaN6RG/HED4rhzbIP8xA18JqgTvOYsCSYlyZW8ljToqKaG8UmmCv
         uWmLnMRK8N5vSH1UVcl1Sq9WCm2S++aZRu4SE=
MIME-Version: 1.0
In-Reply-To: <8db1092f0909281138t18a379d1qdf999b0610ed6414@mail.gmail.com>
References: <8db1092f0909270105x4b49daf8k268e453d2379020c@mail.gmail.com>
	 <2674af740909270127s464a3cb2xef5e7f4cd61b0eb7@mail.gmail.com>
	 <2674af740909270130h359a5d23taa7e8b63e6a18a4d@mail.gmail.com>
	 <8db1092f0909270325j67825cem82fc93cf19336d6f@mail.gmail.com>
	 <2674af740909270701u6febabdbpc5c772fabc193b32@mail.gmail.com>
	 <2674af740909270749u339671a1ia81d5736eeb750fa@mail.gmail.com>
	 <8db1092f0909270916k79d0c369ub93b5e8ddf66c979@mail.gmail.com>
	 <2674af740909271854v191d9768mc3d96f30998f8c01@mail.gmail.com>
	 <8db1092f0909281138t18a379d1qdf999b0610ed6414@mail.gmail.com>
Date: Tue, 29 Sep 2009 13:44:12 +0800
Message-ID: <2674af740909282244g3b53978ev24b9f2a3bd2545cb@mail.gmail.com>
Subject: Re: [2.6.31-git17] WARNING: at kernel/hrtimer.c:648 
	hres_timers_resume+0x40/0x50()/WARNING: at drivers/base/sys.c:353 
	__sysdev_resume+0xc3/0xe0()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, gregkh@suse.de, zambrano@broadcom.com,
       davem@davemloft.net, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 2:38 AM, Maciej Rutecki
<maciej.rutecki@gmail.com> wrote:
> 2009/9/28 Yong Zhang <yong.zhang0@gmail.com>:
>
>>>
>>
>> If you could, then please do it. It can give us some helpful information.
>
> Add patch and remove previous:
> http://unixy.pl/maciek/download/kernel/2.6.31-git17/gumis/dmesg-debug.txt
>
> s2disk&resume twice.
>
> no "timekeeping_resume() called with IRQs enabled!".
>
> I found some interesting thing, warnings appear only once, during
> first s2disk, on second don't appear.
>

Yeah, because WARN_ONCE just print one time.

Thanks,
Yong

> Regards
> --
> Maciej Rutecki
> http://www.maciek.unixy.pl
>
