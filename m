Return-Path: <linux-kernel-owner+w=401wt.eu-S1752761AbYIJF7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbYIJF7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 01:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYIJF7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 01:59:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54568 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbYIJF7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 01:59:42 -0400
Message-ID: <48C76243.5010206@zytor.com>
Date: Tue, 09 Sep 2008 22:59:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: heukelum@fastmail.fm, linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: [RFC/PATCH] i386: handle all exceptions with interrupts off	initially
References: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm> <48C73EB8.8020405@zytor.com> <20080910055337.GA9765@elte.hu>
In-Reply-To: <20080910055337.GA9765@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> the entry paths here are really short (we enable irqs almost 
> immediately) so it's a non-issue in terms of worst-case latencies.
> 
>> In other words, it's not something we want to do "just because", but 
>> to the extent that it provides real benefit, it makes sense.
> 
> this is historically pretty fragile code so bringing the 32-bit and 
> 64-bit variants more in line sounds like a good reason to me. For 
> example we had various long-living irq state annotation bugs (the 
> combination of kprobes and lockdep, etc.) that remained unfixed partly 
> due to this assymetry.
> 

Agreed completely.  I certainly didn't mean to come across sounding 
negative.

	-hpa

