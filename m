Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYGDP4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYGDP4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 11:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbYGDP4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 11:56:33 -0400
Received: from gw.goop.org ([64.81.55.164]:47409 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbYGDP4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 11:56:33 -0400
Message-ID: <486E4827.5070701@goop.org>
Date: Fri, 04 Jul 2008 08:56:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 0 of 8] x86/xen: updated physical mapping patches, and
 _PAGE_GLOBAL cleanup
References: <patchbomb.1214955989@localhost> <20080704103335.GA29615@elte.hu>
In-Reply-To: <20080704103335.GA29615@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> well there are context dependencies so i've put them into x86/xen-64bit.
>
> i picked up these four and merged them into tip/master:
>
> Jeremy Fitzhardinge (4):
>       x86_64/setup: unconditionally populate the pgd
>       x86: always set _PAGE_GLOBAL in _PAGE_KERNEL* flags
>       x86_32: remove __PAGE_KERNEL(_EXEC)
>       x86/cpa: use an undefined PTE bit for testing CPA
>
> the others were either already applied or didnt apply.
>   

Yes, that's fine.  The other patches were a more elegant recasting of an 
existing patch into a more finely bisectable series, which I only needed 
to do to debug the _PAGE_GLOBAL issue.  These four are the really 
interesting parts of the series.

> i'm still testing tip/master but i've pushed out these updates to 
> x86/xen-64bit - you should be able to get the tree i'm testing by doing:
>
>    git-checkout tip/master
>    git-merge tip/x86/xen-64bit
>   

Thanks,
    J
