Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbZGGLGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbZGGLGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 07:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbZGGLGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 07:06:14 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:63055 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbZGGLGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 07:06:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Lml62cBcc3MzGIXSv6Rr1ms7t1h+dBKHwPmGgWGJTHnitQeTzXz7/w5ob9iazCLLFR
         BZPLONIIYbVPkteBIQzbzIOuLGJwW4zajHVPphZCcPBlo7Og9wPuRQg+QOjLF9D6ZMkl
         SkvN03lkSwvgiJLMrhYB3/nVOg1UVVy0ZvBAY=
MIME-Version: 1.0
In-Reply-To: <a5d9929e0907070403n698c9eb9p53a5bb07bafcc169@mail.gmail.com>
References: <200907031326.21822.andres@anarazel.de> <20090707065014.GA3296@ami.dom.local> 
	<a5d9929e0907070340y63280508t92e6c7e4ce464994@mail.gmail.com> 
	<200907071247.16977.andres@anarazel.de> <a5d9929e0907070403n698c9eb9p53a5bb07bafcc169@mail.gmail.com>
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Tue, 7 Jul 2009 12:05:55 +0100
Message-ID: <a5d9929e0907070405p63698ec7t5b5fad394533e4a7@mail.gmail.com>
Subject: Fwd: Soft-Lockup/Race in networking in 2.6.31-rc1+195 ( 
	possibly?caused by netem)
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ing the list and other listeners, that were left out in the previous email.

Joao Correia


---------- Forwarded message ----------
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Tue, Jul 7, 2009 at 12:03 PM
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (
possibly?caused by netem)
To: Andres Freund <andres@anarazel.de>


I dont see the problem with the patch from Jarek. (sorry for not being
clear about this).

With vanilla 31-rc2 it is still there.

Joao Correia

On Tue, Jul 7, 2009 at 11:47 AM, Andres Freund<andres@anarazel.de> wrote:
> On Tuesday 07 July 2009 12:40:16 Joao Correia wrote:
>> I am now running 2.6.31-rc2 for a couple of hours, no freeze.
>>
>> Let me know what/if i can help with tracking down the original source
>> of the problem.
> You dont see the problem anymore with the `echo 0 >
> /proc/sys/kernel/timer_migration`  change (or equivalently with the patch from
> Jarek) or has the problem vanished completely?
>
> Andres
>
