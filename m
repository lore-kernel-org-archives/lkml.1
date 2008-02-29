Return-Path: <linux-kernel-owner+w=401wt.eu-S1759590AbYB2Lf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590AbYB2Lf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 06:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYB2LfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 06:35:15 -0500
Received: from ik-out-1112.google.com ([66.249.90.180]:6643 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbYB2LfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 06:35:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Uxko8qHO1r+Nke/Ns0L/S94pM8xX5LdxLSAZUTv531praGSSl5sge0CkVTbouW41Q14zG0rJ6xwrI5MxmFB2ZClb2uxBFcI8WvQ7erFsvIfW2E8jGYQ8TNjm54f9WVPzJdGuXYkjirVsFViO9IWGXqIBWKHkJ71VUPz68ictsW0=
Message-ID: <47C7EDE4.9040909@gmail.com>
Date: Fri, 29 Feb 2008 12:35:00 +0100
From: Jiri Olsa <olsajiri@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] soft lockup detected with ipcs
References: <47C7E280.4010805@gmail.com>	<20080229025707.971ce0bd.akpm@linux-foundation.org>	<47C7E607.6090308@gmail.com> <20080229032902.a1a235df.akpm@linux-foundation.org>
In-Reply-To: <20080229032902.a1a235df.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 29 Feb 2008 12:01:27 +0100 Jiri Olsa <olsajiri@gmail.com> wrote:
> 
>> Andrew Morton wrote:
>>> On Fri, 29 Feb 2008 11:46:24 +0100 Jiri Olsa <olsajiri@gmail.com> wrote:
>>>
>>>> when I run 'ipcs' my system freeze up immediatelly.
>>>> I was able to get kernel BUG message once, I think it is not
>>>> printed out all the time it freeze.
>>>>
>>>> I tried on 2.6.24, 2.6.20 and 2.6.18.
>>>> I attached screenshot from 2.6.18 freeze and config.
>>> how weird.  Lots of people are surely running ipcs and not seeing this.
>>>
>>> Can you suggest what's different about your setup?
>> no idea :) I noticed like 2 weeks ago... I probably changed some config,
>> but I dont remember what it was, I'll try to figure out.
>>
>> Anyway I can reproduce this immediatelly, so I can run any diag you'd need to see.
>>
> 
> (reversed top-posting - please don't do that ;))
> 
> Strange.  I guess as a first step it would be good if you can get a full
> backtrace - can you set up netconsole
> (Documentation/networking/netconsole.txt) and grab that?
> 
> We have your config.  Can you tell us how you're triggering it?  Does a
> particular workload have to be run, or is it triggerable straight after
> bootup?
> 
> Thanks.

I'll try to get the netconsole..

The trigger is simple just type ipcs and press enter :)
I noticed that running from xterm freeze all the time.
It wont freeze up sometimes running directly from terminal.

I also tried to reproduce it in qemu but with no luck.
