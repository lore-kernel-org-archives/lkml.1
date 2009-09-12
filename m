Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbZILCYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbZILCYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 22:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227AbZILCYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 22:24:36 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:43673 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908AbZILCYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 22:24:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ZRYovqG8p9ALd6zB5pIe2qL/+HIyngtltYX82y4SPQtEUCnvn2Gy3PMRqoG+3WT2lp
         22wCznxCPBjqhAP/47lXozQy28g++747/vPaFiBl/GSqZetlxQ7jx0qGWGNizbM8qx4X
         yBNshFLLvf7WYdiwbPWWjOWh7HOaqsfFmlWbo=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.0909120119190.31018@swampdragon.chaosbits.net>
References: <20090911192505.GA20006@elte.hu>
	 <alpine.LNX.2.00.0909120032270.31018@swampdragon.chaosbits.net>
	 <alpine.LFD.2.01.0909111546050.3654@localhost.localdomain>
	 <alpine.LNX.2.00.0909120119190.31018@swampdragon.chaosbits.net>
Date: Fri, 11 Sep 2009 19:24:38 -0700
X-Google-Sender-Auth: 0719dad730c9a118
Message-ID: <12c511ca0909111924s42d000dsbf378009d9434ddc@mail.gmail.com>
Subject: Re: [GIT PULL] sched/core for v2.6.32
From: Tony Luck <tony.luck@intel.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 4:34 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> That may be so; but most people I've ever talked to about multiple
> processes, fork, vfork and the like, have mostly assumed child-runs-first.
> That is just my personal experience.
> So I get worried when that assumption is made false.

With multi-core cpus becoming (being?) the norm, almost all systems
are SMP now.  So child and parent can surely end up running in parallel
very often.  So applications that make assumptions about child running
first are going to be frequently surprised.  Aren't they?

-Tony
