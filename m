Return-Path: <linux-kernel-owner+w=401wt.eu-S1758350AbYAHBOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbYAHBOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 20:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757780AbYAHBOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 20:14:08 -0500
Received: from gw.goop.org ([64.81.55.164]:44109 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105AbYAHBOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 20:14:07 -0500
Message-ID: <4782CDCE.2030209@goop.org>
Date: Mon, 07 Jan 2008 17:11:42 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 1 of 8] x86: page.h: unify constants
References: <patchbomb.1199391057@localhost> <ba0ec40a50a7aef1a315.1199391058@localhost> <20080107171712.GE2998@bingen.suse.de> <4782A420.30807@goop.org> <20080107231333.GG2998@bingen.suse.de>
In-Reply-To: <20080107231333.GG2998@bingen.suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> THREAD_ORDER should be used on 32bit too.
>
> 32bit also has the equivalent of irq stacks (quite similar) 
> and exception stacks (somewhat different). Currently they use
> other defines, but they could use the same. Also i386 has varying
> irqstack orders disabling them with 8k stacks, but that is something
> that would be best dropped and irqstacks always used imho.
> [...]
> It might be, but it's not a 64bit specific concept.
>   

OK.  That's out of the scope of these particular patches, since they're 
restricting themselves to just unifying what's there.  Another pass 
could definitely tidy a lot more up.

> Yes they do, but hardcoding that doesn't make sense because it varies.
> We already got CPUs with 36, 38, 40 and 48 bits phys size.
>
> The only size that could be hard coded would be 52 bit (theoretical max), but 
> that also doesn't make sense if all we want to do is to mask off NX.
>   

OK.  I'll see how much removing it gains us.

    J
