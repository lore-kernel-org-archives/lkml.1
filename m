Return-Path: <linux-kernel-owner+w=401wt.eu-S1161433AbXBZXzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161433AbXBZXzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 18:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161436AbXBZXzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 18:55:42 -0500
Received: from terminus.zytor.com ([192.83.249.54]:36085 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161433AbXBZXzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 18:55:41 -0500
Message-ID: <45E372CA.9020709@zytor.com>
Date: Mon, 26 Feb 2007 15:52:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: a.gruenbacher@computer.org, nathans@sgi.com, bunk@stusta.de,
       linux-kernel@vger.kernel.org, jmorris@redhat.com, dwmw2@infradead.org
Subject: Re: include/linux/xattr.h: how much userpace visible?
References: <20060724085701.B2083275@wobbly.melbourne.sgi.com>	<200607242031.11815.a.gruenbacher@computer.org>	<45E36D39.2030605@zytor.com> <20070226.154308.112620497.davem@davemloft.net>
In-Reply-To: <20070226.154308.112620497.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
>>>
>> However, it would be better if the ABI constants were exported, or at 
>> least *exportable* (using a __KERNEL_XATTR_MACROS test macro or 
>> something like that.)
> 
> This is the same situation as the socket.h issue we're trying
> to figure out what to do about.
> 
> wrt. the socket.h case I think I'm going to revert the guilty
> changeset for now until a better scheme is implemented

Indeed it is (as well as <linux/stat.h>).

I believe the use of feature macros is probably the way to go; that way 
userspace can request subsets, which can vary from libc to libc.

There is, of course, the "ABI language" variant, but I don't see that 
happening unless someone has a lot of time to spend on it.

	-hpa
