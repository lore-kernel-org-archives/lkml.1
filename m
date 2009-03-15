Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbZCOSEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbZCOSEv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 14:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbZCOSEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 14:04:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:53141 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbZCOSEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 14:04:42 -0400
Message-ID: <49BD42F5.7070808@kernel.org>
Date: Sun, 15 Mar 2009 11:03:33 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: print out in e820_update_range()
References: <49BCB557.3030000@kernel.org> <20090315080717.GA18978@elte.hu>
In-Reply-To: <20090315080717.GA18978@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Impact: to find crazy calling
>>
>> try to print out more info, to catch wrong calling
> 
> Could we detect incorrect parameters more directly as well, via 
> a check and a panic()?

only valid checking seems to be 
virt_to_phys(_text), virt_to_phys(_end)


if (new_type == E820_RESERVED && start >= virt_to_phys(_text) && start <= virt_to_phys(_end)) 
	panic("try to update to e820 range for kernel to RESERVED!");

YH
