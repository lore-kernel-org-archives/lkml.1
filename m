Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbXJYR54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbXJYR54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbXJYR5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:57:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49365 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbXJYR5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:57:46 -0400
Message-ID: <4720D8EA.1090501@zytor.com>
Date: Thu, 25 Oct 2007 10:56:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, glommer@gmail.com
Subject: Re: [PATCH] Wipe out traditional opt from x86_64 Makefile
References: <11933164723812-git-send-email-gcosta@redhat.com> <20071025173605.GM30533@stusta.de>
In-Reply-To: <20071025173605.GM30533@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, Oct 25, 2007 at 09:47:52AM -0300, Glauber de Oliveira Costa wrote:
>> Among other things, using -traditional as a gcc option stops us from
>> using macro token pasting, which is a feature we heavily rely on.
>>
>> There was still a use of -traditional in arch/x86/kernel/Makefile_64,
>> which this patch removes.
>>
>> I don't see any problems building kernels in my x86_64 box without
>> -traditional.
>> ...
> 
> Does it also work with gcc 3.2 ?
> 

It wouldn't be a gcc version issue, it would be a binutils (ld) version 
issue.

	-hpa
