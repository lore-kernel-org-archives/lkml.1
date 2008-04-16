Return-Path: <linux-kernel-owner+w=401wt.eu-S1760110AbYDPCoC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbYDPCoC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 22:44:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbYDPCnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 22:43:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53401 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbYDPCnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 22:43:51 -0400
Message-ID: <480566D4.1080904@cn.fujitsu.com>
Date: Wed, 16 Apr 2008 10:39:16 +0800
From: Shen Feng <shen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: why 2 Kernel command line and module option parsers
References: <48045829.1090609@cn.fujitsu.com> <480517DC.3060303@redhat.com>
In-Reply-To: <480517DC.3060303@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Chris Snook Wrote:
> Shen Feng wrote:
>> Hello,
>>
>> Now we get two Kernel command line and module option parsers, i.e.
>> lib/cmdline.c
>> lib/parser.c
>>
>> I think we'd better merge them into one and make a kernel option
>> standard since
>> the kernel options become more and more.
> 
> Are you volunteering?
> 
> 

OK. I also found another parser in kernel/params.c.

I will try to supply a new parser and a kernel option standard as
Documentation/kernel-parameter-parser.txt
include/linux/kparser.h
lib/kparser.c

to replace
lib/cmdline.c
lib/parser.c
and part of kernel/params.c
