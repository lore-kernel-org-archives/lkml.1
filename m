Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbXFVRL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbXFVRL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbXFVRLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:11:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995AbXFVRLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:11:49 -0400
Message-ID: <467C02AA.2080105@redhat.com>
Date: Fri, 22 Jun 2007 13:11:06 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jesper Juhl <jesper.juhl@gmail.com>,
       =?ISO-8859-1?Q?Zolt=E1n_HUBERT?= <zoltan.hubert@zzaero.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Please release a stable kernel Linux 3.0
References: <200706212349.54983.zoltan.hubert@zzaero.com> <9a8748490706211529yca0588dgd1f7e0b86f7e4a62@mail.gmail.com> <467AFCEC.2070203@redhat.com> <200706221700.08135.rjw@sisk.pl>
In-Reply-To: <200706221700.08135.rjw@sisk.pl>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2007 11:00 AM, Rafael J. Wysocki wrote:
> On Friday, 22 June 2007 00:34, Chuck Ebbert wrote:
>> On 06/21/2007 06:29 PM, Jesper Juhl wrote:
>>> I myself have argued that we should be focusing more on stability and
>>> regression fixing, but I'm not so sure that a 2.6.7 devel branch would
>>> solve this. In general the 2.6.x.y -stable kernels seem to be doing
>>> the job pretty good.
>>>
>>  
>> Even the good ones that get lots of fixes aren't all that good. The
>> biggest problem ATM is that suspend is badly broken and keeps getting
>> worse...
> 
> Can you please provide me with any links to suspend-related bug reports from
> you?
> 

I get so many suspend/resume bug reports that I've given up trying
to get them fixed. And there are so many bugs that are even worse,
like crashes during normal use, data corruption, etc. that suspend
bugs don't get much attention. But here are the ones for Fedora 6;
the list would be much longer if I included Fedora 5 and 7:

Suspend to memory does not work anymore on Acer TM 740
	https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=216372

Power off and suspend-to-RAM not working on Sony Vaio VGN-C140G
	https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=218341

Thinkpad T43 fails to resume after suspend
	https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=220977

suspend does not work on 2.6.19-1.2895 (worked great on 2.6.18-1.2869)
	https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=223731

problems by suspend after a resume from suspend
	https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=224141

System crash on suspend
	https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=225028

Suspend fails with latest kernel
	https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=225062

Suspend to RAM fails after upgrade to 2.6.19-1.2895.fc6
	https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=227789

Touchpad does not work after resume from suspend to ram
	https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229201

System ceased to resume from suspend on Toshiba Satellite A100-847
	https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229464

2.6.19* kernels won't suspend / resume laptop; 2.6.18 works fine.
	https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=230853

Unexpectedly high power drain while suspended
	https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=230947

Laptop overheats on resume from suspend to ram
	https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=233246

Kernel 2933 crashes laptop on suspend
	https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=234622

Kernel oops after attempted suspend
	https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=244245
