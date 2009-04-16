Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZDPDQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZDPDQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 23:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZDPDP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 23:15:57 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:43094 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbZDPDP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 23:15:56 -0400
Date: Thu, 16 Apr 2009 08:45:04 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Dan Malek <dan@embeddedalley.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>
Subject: Re: [PATCH] Memory usage limit notification addition to memcg
Message-ID: <20090416031504.GC7082@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1239660512-25468-1-git-send-email-dan@embeddedalley.com> <20090415093555.d84b6655.kamezawa.hiroyu@jp.fujitsu.com> <20090415082446.GT7082@balbir.in.ibm.com> <9272A08E-4928-486D-84D3-4593300B017A@embeddedalley.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <9272A08E-4928-486D-84D3-4593300B017A@embeddedalley.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dan Malek <dan@embeddedalley.com> [2009-04-15 10:35:20]:

>
> On Apr 15, 2009, at 1:24 AM, Balbir Singh wrote:
>
>> Welcome! I've taken a cursory look at the patches, but I'll come back
>> with more review comments.
>
> I'm going to submit a new patch shortly, so let's wait and review that
> one.  Too many updates since the first time I sent it.
>

OK, I was going to advice using cgroupstats for notification.
cgroupstats builds on top of taskstats

Please see

1. Documentation/accounting/*
2. kernel/taskstats.c

getdelays.c (available under (1)) provides the user space application
to make use of taskstats and cgroupstats.

Using that will allow you to

1. Provide type information with every event (extensible)
2. Reuses existing well tested code in the form of genetlink and
netlink


>> ...   Could you point me to your
>> presentation/paper? I could not find the PDF at
>> http://www.celinuxforum.org/CelfPubWiki/ELC2009Presentations
>
> Apologies.  I just uploaded it now.  There was an hour of
> talking that goes along with that, which I hope will explain some
> of the points on the slides.  The video was recorded, I assume it
> will show up someplace, someday :-)
>

I was able to download it, Thanks!

-- 
	Balbir
