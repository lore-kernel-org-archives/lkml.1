Return-Path: <linux-kernel-owner+w=401wt.eu-S1760522AbYG1RUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760522AbYG1RUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756700AbYG1RUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:20:14 -0400
Received: from mail.tmr.com ([64.65.253.246]:41495 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759926AbYG1RUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:20:13 -0400
Message-ID: <488E01CA.7000302@tmr.com>
Date: Mon, 28 Jul 2008 13:28:42 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: luis6674@yahoo.com, linux-kernel@vger.kernel.org
Subject: Re: How to disable group scheduler correctly?
References: <842240.12654.qm@web53310.mail.re2.yahoo.com>	 <488D03A9.4020103@tmr.com> <6599ad830807280947j21fda44ajd51ce1dd523d9472@mail.gmail.com>
In-Reply-To: <6599ad830807280947j21fda44ajd51ce1dd523d9472@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Sun, Jul 27, 2008 at 4:24 PM, Bill Davidsen <davidsen@tmr.com> wrote:
>   
>> Would be nice to have a clean way to do this at runtime, so you could run a
>> distribution kernel and just avoid the group part of the scheduling.
>>     
>
> If the cgroups scheduler is enabled but you don't actually create any
> cpu scheduler cgroups, then you're just scheduling across a single
> group that contains all processes/threads. Is that distinguishable
> from not having group scheduling at all?
>   

In decisions, hopefully not. But given that there are other places in 
kernel which allow code to be bypassed completely, a flag which would 
simply avoid ever going into the code would not be a new idea. In the 
network code there are flags to prevent passing packets in a bridge 
through iptables, something similar could be provided in scheduling. It 
actually makes sense to default the flag to "no cgroups" asnd only 
enable it if cgroups have been defined.

There is no optimization faster than not executing the code.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


