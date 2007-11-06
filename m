Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbXKFBgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbXKFBgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 20:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbXKFBgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 20:36:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34317 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbXKFBgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 20:36:42 -0500
Message-ID: <472FC454.4040701@zytor.com>
Date: Mon, 05 Nov 2007 17:33:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Sam Ravnborg <sam@ravnborg.org>, Roland Dreier <rdreier@cisco.com>,
       Christoph Hellwig <hch@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] replace "make ARCH=i386/x86_64 with make ARCH=x86"
References: <20071103234826.GA26654@uranus.ravnborg.org> <20071105104129.GB3662@infradead.org> <20071105171740.GA29481@uranus.ravnborg.org> <adafxzkbcid.fsf@cisco.com> <20071105214937.GA31496@uranus.ravnborg.org> <472FAB4C.9040303@zytor.com> <20071106012916.GE3444@stusta.de>
In-Reply-To: <20071106012916.GE3444@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
>>
>> The issue with "make allyesconfig" concerns me, although the same situation 
>> already exists with any multiple-choice configuration.  What I guess we 
>> really want is to be able to specify a few specific choices.
> 
> It's already available:
> 
> $ cat myconfig
> CONFIG_HIGHMEM64G=y
> CONFIG_SMP=n
> CONFIG_PCI=n
> CONFIG_IPV6=m
> $ make allyesconfig KCONFIG_ALLCONFIG=myconfig
> 

OK.  It would be nicer to be able to specify things via variables 
directly on the command line, but definitely fills the need.

	-hpa
