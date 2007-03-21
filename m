Return-Path: <linux-kernel-owner+w=401wt.eu-S933408AbXCUW3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408AbXCUW3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933886AbXCUW3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:29:42 -0400
Received: from gw.goop.org ([64.81.55.164]:60653 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933408AbXCUW3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:29:41 -0400
Message-ID: <4601B1D4.8060908@goop.org>
Date: Wed, 21 Mar 2007 15:29:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: remove-unused-header-file-include-linux-elfnoteh.patch
References: <4601A56A.40609@goop.org> <200703212320.35920.arnd@arndb.de>
In-Reply-To: <200703212320.35920.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 21 March 2007 22:36:42 Jeremy Fitzhardinge wrote:
>   
>> Please don't.  We need it.
>>
>> BTW, I didn't see this one go by, and I couldn't see it searching
>> around.  Did it get posted to lkml?
>>     
>
> I think it was only on the janitor list. It was considered
> obviously correct since it does not get installed by
> headers_installed and did not seem to be used anywhere in
> the kernel.
>
> Could you explain how this file is used in the kernel? Robert
> probably wants to update his script to handle this correctly.

It's used in the Xen patch series, which I'm actively trying to upstream
at the moment.  There are also a couple of other places in the kernel
which generate ELF notes, and they could probably be changed to use this
common header.

    J
