Return-Path: <linux-kernel-owner+w=401wt.eu-S1759805AbYBFF7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805AbYBFF7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 00:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbYBFF72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 00:59:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38006 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYBFF71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 00:59:27 -0500
Message-ID: <47A94CB8.3020303@zytor.com>
Date: Tue, 05 Feb 2008 21:59:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: hasan@digitalpath.net, linux-kernel@vger.kernel.org
Subject: Re: Access MSR functions in userspace?
References: <3278.65.164.104.9.1202268587.squirrel@webmail.digitalpath.net> <200802060600.35498.maximlevitsky@gmail.com>
In-Reply-To: <200802060600.35498.maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky wrote:
> On Wednesday, 6 February 2008 05:29:47 Hasan Rashid wrote:
>> Is there a way to use RDMSR and WRMSR in userspace? I only need to write
>> to one register, writing a module with a userspace piece to handle that
>> seems like an over kill.
>>
>> TIA!
> 
> 
> Fortunately linux have /dev/cpu/*/msr
> Take  look at $LINUX_SOURCES/arch/x86/kernel/msr.c to learn how to use it.
> 

You might also find these useful:

http://www.kernel.org/pub/linux/utils/cpu/msr-tools/msr-tools-1.1.2.tar.bz2

	-hpa
