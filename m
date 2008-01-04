Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbYADKnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbYADKnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 05:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYADKnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 05:43:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49223 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbYADKni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 05:43:38 -0500
Date: Fri, 4 Jan 2008 11:43:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, olof@lixom.net
Subject: Re: [patch 2/2] Add the end-of-trace marker and the module list to
	WARN_ON()
Message-ID: <20080104104322.GA18199@elte.hu>
References: <477D5340.9090809@linux.intel.com> <20080104074523.GD17447@elte.hu> <477E0CAB.2040402@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477E0CAB.2040402@linux.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> Ingo Molnar wrote:
>> * Arjan van de Ven <arjan@linux.intel.com> wrote:
>>
>>> +	printk(KERN_WARNING "------------[ cut here ]------------\n");
>>>  	printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
>>>  		line, function);
>>> +	print_modules();
>>>  	dump_stack();
>>> +	print_oops_end_marker();
>>
>> another thing: could we also put the marker into dump_stack(), and attach 
>> the marker to the Call Trace line?
>
> I have a preliminary patch for that already but I'm not happy with it 
> yet; I need to redo it properly. It's neither depending nor 
> incremental to these 2 patches though..

yeah, it was a sidenote - it should be separate to these two patches.

	Ingo
