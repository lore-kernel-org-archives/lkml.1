Return-Path: <linux-kernel-owner+w=401wt.eu-S1763311AbYESX4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763311AbYESX4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758059AbYESXz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:55:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43349 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026AbYESXz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:55:58 -0400
Message-ID: <48321299.80303@zytor.com>
Date: Mon, 19 May 2008 16:51:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Harvey Harrison <harvey.harrison@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] asm-generic/int-ll64.h: always provide __{s,u}64
References: <20080519215452.GK17716@cs181133002.pp.htv.fi> <4831F89F.5060106@zytor.com> <1211236048.5915.94.camel@brick> <20080519223232.GB17716@cs181133002.pp.htv.fi>
In-Reply-To: <20080519223232.GB17716@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
>>>
>> If it is going to be unconditionally offered, we could get rid of
>> __BYTEORDER_HAS_U64__ as a next step.  Unless there is something I've
>> missed.
> 
> Why do we need the byteorder headers in userspace at all?
> 

Because Linux-specific software has depended on them for over 15 years 
(they are a much better API than anything POSIX provides.)  We can't 
just yank them, and so it's better if they actually work.

Yes, you can argue it should be glibc's job to provide them, but well, 
why duplicate work when we already have a nicely working set.

	-hpa
