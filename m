Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbZJZFDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbZJZFDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 01:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbZJZFDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 01:03:15 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:51249 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbZJZFDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 01:03:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YI6hpsugA3KNAUOu9kFgdu2hWcX9vAQjbUwoLby4ODChXIy8B94BxtcGoSQ4VwEE4r
         aGa0Rbo1Up22WKkIfrCeSF6XbbAgsAX+k2UkhBny0PriVKIfF5X/Xgn6oR53FLO9mB89
         elav4uLcOkhtECbiWiNOI4RzxtBj1k4Tdm0/c=
MIME-Version: 1.0
In-Reply-To: <023001ca55e1$436e38e0$808410ac@zhaoleiwin>
References: <20091023160257.GA30447@Krystal> <20091023160632.GA2198@Krystal>
	 <alpine.LNX.2.00.0910242300510.16628@swampdragon.chaosbits.net>
	 <20091026015357.GA6033@localhost>
	 <023001ca55e1$436e38e0$808410ac@zhaoleiwin>
Date: Mon, 26 Oct 2009 14:03:19 +0900
Message-ID: <49b7c2350910252203o69811000w4551c01e6e2a10c7@mail.gmail.com>
Subject: Re: Relicensing tracepoints and markers to Dual LGPL v2.1/GPL 
	v2,headers to Dual BSD/GPL
From: GeunSik Lim <leemgs1@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jesper Juhl <jj@chaosbits.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Adrian Bunk <bunk@stusta.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Michel Dagenais <michel.dagenais@polymtl.ca>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 11:08 AM, Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> * From: "Wu Fengguang" <fengguang.wu@intel.com>
> Subject: Re: Relicensing tracepoints and markers to Dual LGPL v2.1/GPL v2,headers to Dual BSD/GPL
>
>
>> On Sun, Oct 25, 2009 at 05:03:52AM +0800, Jesper Juhl wrote:
>>> On Fri, 23 Oct 2009, Mathieu Desnoyers wrote:
>>>
>>> > (updated email for Jesper Juhl)
>>> >
>>> > * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
>>> > > Hi,
>>> > >
>>> > > I would like to re-license the tracepoint.c/marker.c files from GPL to:
>>> > >
>>> > > * Dual LGPL v2.1/GPL v2 license.
>>> > >
>>> > > And re-license tracepoint.h/marker.h to:
>>> > >
>>> > > * Dual BSD/GPL v2 license.
>>> > >
>>> > > The goal is to allow sharing code between the kernel tracer and UST
>>> > > (User-Space Tracer) project, which is a LGPL v2.1 library. Tracepoint
>>> > > and marker headers might need to be included by proprietary or BSD
>>> > > applications, hence the dual BSD/GPL v2 license for these two.
>>> > >
>>> > > I currently have the OK from Kosaki Motohiro for Fujitsu contributions,
>>> > > which includes Zhao Lei and Lai Jiangshan.
>>> > >
>>> > > The missing approvals for Dual LGPL v2.1/GPL v2 relicensing are:
>>> > >
>>> > > For tracepoint.c:
>>> > >
>>> > > Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
>>> > >
>>> > > For marker.c:
>>> > >
>>> > > "Robert P. J. Day" <rpjday@mindspring.com>
>>> > > Adrian Bunk <bunk@stusta.de>
>>> > > Harvey Harrison <harvey.harrison@gmail.com>
>>> >
>>> > Jesper Juhl <jj@chaosbits.net>
>>> >
>>>
>>> I don't think I have enough significant changes in there to actually
>>> require my approval for relicensing, but since you ask; I personally
>>> do not have a problem with that file being Dual LGPL v2.1/GPL v2
>>> licensed.
>>
>> Me too.
>>
>> Thanks,
>> Fengguang
>
> Me too.
>
> Thanks,
> Zhaolei

Sorry for the late reply. Why do we need a different license to GPLV2
sources that  contributors submitted.?  As Mathieu mentioned, I think
that  GPLV2 based some sources needs  to be relicense  to  trace
non-GPL applications
for some developers and some companies.

In real, Some open source  like QT, MySQL is licensed using dual
license for business strategy. tracepoint.c/marker.c file is GPLv2
currently.

Can  we re-distribute with dual license (e.g: bsd/gplv2 or lgpl
2.1/gplv2)   about some source of linux kernel source? I think that
linux kernel source is GPLv2 only. Frankly speaking, I am not know
exactly about  legal issues of your questions.

Thanks,


-- 
Regards,
GeunSik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
