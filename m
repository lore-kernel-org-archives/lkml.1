Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbZGXNor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbZGXNor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 09:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbZGXNoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 09:44:46 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:55638 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbZGXNoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 09:44:46 -0400
X-Greylist: delayed 2398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jul 2009 09:44:45 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rIc5eDA/VNJsYF3+tCrqWEVceVkA2J6NQVutDzwmAAxSeG8JfSw/K8M8w2cDoPomEA
         xggEV6nE9QJUInb/Y3ovribIxjt2YKqob8WbTRXym6cP7eBw1Jp7kB5XPwWs9mWgSw8k
         iNcQkrkxUa4B1QluAk6nF5VlVI/XfQW/ZyG0A=
MIME-Version: 1.0
In-Reply-To: <1248442415.6987.56.camel@twins>
References: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com>
	 <1248437670.6987.26.camel@twins>
	 <454c71700907240604h4673f117j8ed58b9f2ee54798@mail.gmail.com>
	 <1248441290.6987.52.camel@twins>
	 <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com>
	 <1248442415.6987.56.camel@twins>
Date: Fri, 24 Jul 2009 21:44:43 +0800
Message-ID: <454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com>
Subject: Re: report a bug about sched_rt
From: sen wang <wangsen.linux@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/24 Peter Zijlstra <peterz@infradead.org>:
> On Fri, 2009-07-24 at 21:26 +0800, sen wang wrote:
>> don't tell me what theory. don't be so doctrinairism! OK?
>> If cpu is free and there is a running state task,how can you scdedule
>> idle task up?
>> I tell you again:we are not talking about a bandwidth of 100% for RT!
>> Bug lies in the bandwidth of (100- X)%.(X<100)
>> even in the time of 100-X,if there is a rt task, you should not idle()
>> the system.
>
> *sigh*
>
> Yes we should. I appreciate that you might assume otherwise, but you're
> wrong. Suppose you have two competing bandwidth groups, which one will
> run over, to what purpose?
>
> Also, your next top post will go to /dev/null.
>


OK !  maybe you has not understand what I said.
It not two competing bandwidth groups. there is a  active group and
another is empty?
How you do?
Why not try it by your hand: empty the fair task, run a rt task,enable
the  bandwidth and
see what will happen!

In many embedded system,idle task will lead to shutdown something, but
the rt task will
assume: when it run, idle will not happen!
