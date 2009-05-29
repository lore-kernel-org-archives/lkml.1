Return-Path: <linux-kernel-owner+w=401wt.eu-S1763386AbZE2UTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763386AbZE2UTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761128AbZE2UTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:19:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45652 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450AbZE2UTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:19:39 -0400
Message-ID: <4A204313.9090102@zytor.com>
Date: Fri, 29 May 2009 13:18:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com,
       seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org, apw@canonical.com
Subject: Re: [tip:x86/mce3] x86, mce: trivial clean up for mce_intel_64.c
References: <tip-61a021a0700c22ee527d73d92f9acb109ff478f8@git.kernel.org> <20090529200305.GC1065@one.firstfloor.org>
In-Reply-To: <20090529200305.GC1065@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> x86, mce: trivial clean up for mce_intel_64.c
>>
>> Fix for:
>>
>> WARNING: space prohibited between function name and open parenthesis '('
>> +       for_each_online_cpu (cpu) {
> 
> Sorry but that's just a bogus change. That's a loop and we always
> put spaces between the loop keyword and its condition.
> 
> Just because checkpatch.pl is too dumb to understand that is no
> reason to make the code worse like that.
> 

Look at EVERY OTHER for_each_online_cpu in the kernel.

	-hpa

