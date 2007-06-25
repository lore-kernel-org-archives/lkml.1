Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbXFYQiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbXFYQiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 12:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbXFYQip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 12:38:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbXFYQio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 12:38:44 -0400
Message-ID: <467FEF6E.9050908@redhat.com>
Date: Mon, 25 Jun 2007 12:38:06 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jesper Juhl <jesper.juhl@gmail.com>,
       =?ISO-8859-1?Q?Zolt=E1n_HUBERT?= <zoltan.hubert@zzaero.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Please release a stable kernel Linux 3.0
References: <200706212349.54983.zoltan.hubert@zzaero.com> <200706221700.08135.rjw@sisk.pl> <467C02AA.2080105@redhat.com> <200706242254.59695.rjw@sisk.pl>
In-Reply-To: <200706242254.59695.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2007 04:54 PM, Rafael J. Wysocki wrote:
> On Friday, 22 June 2007 19:11, Chuck Ebbert wrote:
>> On 06/22/2007 11:00 AM, Rafael J. Wysocki wrote:
>>> On Friday, 22 June 2007 00:34, Chuck Ebbert wrote:
>>>> On 06/21/2007 06:29 PM, Jesper Juhl wrote:
>>>>> I myself have argued that we should be focusing more on stability and
>>>>> regression fixing, but I'm not so sure that a 2.6.7 devel branch would
>>>>> solve this. In general the 2.6.x.y -stable kernels seem to be doing
>>>>> the job pretty good.
>>>>>
>>>>  
>>>> Even the good ones that get lots of fixes aren't all that good. The
>>>> biggest problem ATM is that suspend is badly broken and keeps getting
>>>> worse...
>>> Can you please provide me with any links to suspend-related bug reports from
>>> you?
>>>
>> I get so many suspend/resume bug reports that I've given up trying
>> to get them fixed. And there are so many bugs that are even worse,
>> like crashes during normal use, data corruption, etc. that suspend
>> bugs don't get much attention. But here are the ones for Fedora 6;
>> the list would be much longer if I included Fedora 5 and 7:
> 
> Can you please tell me what's the relationship between Fedora kernel vesions
> and the kernel.org kernels?
> 

Fedora kernels are as close to upstream as we can get them, but we do add Xen,
Roland's utrace and exec-shield. The list of applied patches may be a bit long
but most of them are bug fixes that we couldn't get into -stable for one reason
or another (some not upstream yet, some judged too big for -stable.)
