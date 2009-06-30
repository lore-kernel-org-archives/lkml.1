Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZF3JOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZF3JOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 05:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbZF3JOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 05:14:31 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:37274 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbZF3JOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 05:14:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Cn/Pgfbb8iyUqMVgXk0nwOEAipXXhNiTEPnspt4Oxr7lfZGgLVnom3ngShg9w/CnLw
         /fJFBAFYOG9aMZv74WFbkeRnBKVlYulQTV1Ua2AZL/20n0MS0xP+NLrklCJ1fC9JrZmj
         c7dPGNgBfk4FoxSG7pipGenAPL3Cqge+B27/g=
Date: Tue, 30 Jun 2009 17:16:40 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl
Subject: Re: Crashes during boot on 2.6.30 / 2.6.31-rc, random programs
Message-ID: <20090630091640.GB5873@cr0.nay.redhat.com>
References: <a5d9929e0906270807s4c0ef74ap2296dce4c790ea9a@mail.gmail.com> <2375c9f90906281908k7aa089a3v932dd368d572194b@mail.gmail.com> <a5d9929e0906290153g305427c6j37f96db060cb4738@mail.gmail.com> <20090629091508.GA6308@cr0.nay.redhat.com> <a5d9929e0906290330s704d5848nb36ce2d37dc9124b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5d9929e0906290330s704d5848nb36ce2d37dc9124b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 11:30:41AM +0100, Joao Correia wrote:
>Hello
>
>The system seemed to happily ignore all the sysctl.conf changes and
>all echo VALUE >  /proc/sys/kernel/max_lock_depth


Ouch, mistake! max_lock_depth is for rt_mutex... :)

>
>So i dug a little on the source and changed
>
>include/linux/sched.h
>
># define MAX_LOCK_DEPTH 48UL
>
>to
>
># define MAX_LOCK_DEPTH 96UL
>
>and im getting no more errors. Of course, now its probably radioactive
>and about to blow up, but at least it's not complaining anymore :).

Yeah, this is right.

Let's Cc: Peter to see if he would like to change this number...

Peter?
