Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab0CLIXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 03:23:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285Ab0CLIXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 03:23:47 -0500
Message-ID: <4B99F9A4.9010203@redhat.com>
Date: Fri, 12 Mar 2010 10:21:56 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Clark Williams <williams@redhat.com>,
       =?UTF-8?B?Ikx1aXMgQ2xhdWRpbyBSLiBH?= =?UTF-8?B?b27Dp2FsdmVzIg==?= 
	<lclaudio@redhat.com>
Subject: Re: [PATCH v2 5/5] perf report: Initial TUI using newt
References: <1268349164-5822-1-git-send-email-acme@infradead.org> <1268349164-5822-5-git-send-email-acme@infradead.org> <20100311232952.GF28421@ghostprotocols.net>
In-Reply-To: <20100311232952.GF28421@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2010 01:29 AM, Arnaldo Carvalho de Melo wrote:
> Em Thu, Mar 11, 2010 at 08:12:44PM -0300, Arnaldo Carvalho de Melo escreveu:
>    
>> From: Arnaldo Carvalho de Melo<acme@redhat.com>
>>
>> Newt has widespread availability and provides a rather simple API as can be
>> seen by the size of this patch.
>>
>> The work needed to support it will benefit other frontends too.
>>
>> In this initial patch it just checks if the output is a tty, if not it falls
>> back to the previous behaviour, also if newt-devel/libnewt-dev is not installed
>> the previous behaviour is maintaned.
>>
>> Pressing enter on a symbol will annotate it, ESC in the annotation window will
>> return to the report symbol list.
>>      
> For those not so curious as to apply and try it out, here is a
> screenshot of it in action:
>
> http://tglx.de/~acme/perf-newt.png
>
>    

Looks really useful!

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

