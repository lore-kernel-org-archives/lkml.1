Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbZGJO0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbZGJO0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 10:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbZGJO0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 10:26:24 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:47647 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZGJO0X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 10:26:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NdJvAa7bilQjgmgerz/tjE1aqnSmfYI+s7Ylw58CrIoL4yUIHbPwZBB06u+Kf/VaJw
         QTkBHMAfiR2KekxkhnNISJHbf1vHxa/vt2VuEwXQ2dhuPpOFLNP4T7pWzHMHpnX/LHLW
         0IMbpSnQQmDj5U68lLSj+ewVZfG0iFXYrsLYI=
MIME-Version: 1.0
In-Reply-To: <20090710141618.GF26264@elte.hu>
References: <200907040017.26921.rgetz@blackfin.uclinux.org> 
	<200907091308.37370.rgetz@blackfin.uclinux.org> <20090710102547.GD5499@elte.hu> 
	<200907101013.56177.rgetz@blackfin.uclinux.org> <20090710141618.GF26264@elte.hu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 10 Jul 2009 10:26:01 -0400
Message-ID: <8bd0f97a0907100726i6d00c75q1189080dea711831@mail.gmail.com>
Subject: Re: [PATCH] kernel.printk.c - ensure that "console enabled"messages 
	are printed on the console
To: Ingo Molnar <mingo@elte.hu>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 10:16, Ingo Molnar wrote:
> * Robin Getz wrote:
>> On Fri 10 Jul 2009 06:25, Ingo Molnar pondered:
>> >  - re-broke the commit log as it was too wide for nice git log
>> >    output
>>
>> Hmm - I didn't know there was a restriction on this - what is the number?
>
> 'git log' adds 4 leading spaces to commit messages and then if you
> look at it via a small terminal it can quickly wrap at the end,
> making the commit log harder to read.
>
> Also, commit logs get quoted in emails and if we reply to that in up
> to a depth of 4, the colums do get eaten up quickly.
>
> 60 cols sounds like a reasonable compromise. There's no 'written'
> rule for this AFAIK, i just do it for all changes i commit, to
> increase commit quality.

the upper rule based on what you point out:
 - git-log adds 4 and 80 cols is the min directly supported
 - logs go through e-mail which wraps at 78
leaves us with user-typed paragraphs at 76

for copy & pasted output (i.e. gcc output and kernel crash logs), i
welsh on that a bit as it leaves it up to the viewer to wrap like
normal.
-mike
