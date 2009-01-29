Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbZA2Osz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbZA2Osz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbZA2Osp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:48:45 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:5178 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbZA2Oso convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:48:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QnsrUH/gN3bbTvyoGyHndb274Km22s9z4Vb8HhKhrsgL2kN3WnGQ/EGQ6oMXF0C3x2
         SbzHj6hvTQb3JXs0wadYoUa31+FvyYzLG9e9LIPf7qEa5GGrk2us+ORDfd8gQEny+EbB
         slGu/8egag9CUmsYIyw/1TiRQzQGmo4WX+Qd0=
MIME-Version: 1.0
In-Reply-To: <c62985530901290640j10e63127s59ce22e860a508f8@mail.gmail.com>
References: <497F69A4.2070007@intel.com> <20090127224303.GB5850@nowhere>
	 <20090127225048.GA4652@nowhere> <20090129140451.GM24391@elte.hu>
	 <c62985530901290629i168ac12cjc4b22140caceff58@mail.gmail.com>
	 <20090129143120.GS24391@elte.hu>
	 <c62985530901290640j10e63127s59ce22e860a508f8@mail.gmail.com>
Date: Thu, 29 Jan 2009 15:48:41 +0100
Message-ID: <c62985530901290648r4a97bdb1i783f77da7ec48e34@mail.gmail.com>
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       powertop ml <power@bughost.org>,
       Arjan van de Ven <arjan@linux.intel.com>, srostedt@redhat.com,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>, utrace-devel@redhat.com,
       Roland McGrath <roland@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/29 Frédéric Weisbecker <fweisbec@gmail.com>:
> 2009/1/29 Ingo Molnar <mingo@elte.hu>:
>>>
>>> Several people talked me about utrace and gave some examples about it in
>>> this discussion. The Api is very convenient to fetch syscall numbers,
>>> arguments and return values. And the hooks are done in the generic core
>>> code, so it is arch independent.
>>>
>>> The only drawback I can see is that it is not yet merged upstream, in
>>> need of in-kernel users. If it only depends on this condition, we could
>>> be these users...
>>>
>>> What do you think?
>>
>> sure - how do the minimal bits/callbacks look like which enable syscall
>> tracing?
>>
>>        Ingo
>
>
> There is a very straightforward example provided by Ananth in there:
> http://lkml.org/lkml/2009/1/28/59
>

One other drawback may be the fact that utrace will be traced by the
function tracers... adding some junk on their traces.
But I guess this is just a matter of some patches to make it not traced.

BTW, there is an interesting proof of concept there:
http://lkml.org/lkml/2009/1/27/294
