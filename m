Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbZBSQc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbZBSQc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 11:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbZBSQct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 11:32:49 -0500
Received: from gw.goop.org ([64.81.55.164]:47435 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbZBSQct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 11:32:49 -0500
Message-ID: <499D89AF.5010406@goop.org>
Date: Thu, 19 Feb 2009 08:32:47 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Petr Tesarik <ptesarik@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Definition of BUG on x86
References: <499C4786.5010504@goop.org> <1235043648.15053.35.camel@nathan.suse.cz> <20090219121027.GB1703@elte.hu> <1235045971.15053.42.camel@nathan.suse.cz> <20090219122211.GE1703@elte.hu> <1235047082.15053.49.camel@nathan.suse.cz> <20090219124702.GC22044@elte.hu> <1235048535.15053.52.camel@nathan.suse.cz> <20090219144902.GA8650@elte.hu> <499D7B9D.7060001@goop.org> <20090219153544.GA31637@elte.hu>
In-Reply-To: <20090219153544.GA31637@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> could we just do:
>
> 	__builtin_trap();
> 	for (;;);
>
> and _now_ GCC would optimize away the infinite loop? And if it 
> does something silly in a future release, we'd either get a 
> build error or we'd run into the infinite loop for sure.
>   

I guess that would work.  And we have plenty of infrastructure and 
precedent for compiler-dependent defines like this.

    J
