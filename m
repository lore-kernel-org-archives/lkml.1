Return-Path: <linux-kernel-owner+w=401wt.eu-S1751345AbXBZXeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbXBZXeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 18:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbXBZXeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 18:34:06 -0500
Received: from terminus.zytor.com ([192.83.249.54]:40851 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbXBZXeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 18:34:05 -0500
Message-ID: <45E36D39.2030605@zytor.com>
Date: Mon, 26 Feb 2007 15:28:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andreas Gruenbacher <a.gruenbacher@computer.org>
CC: Nathan Scott <nathans@sgi.com>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org, James Morris <jmorris@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: include/linux/xattr.h: how much userpace visible?
References: <20060723184343.GA25367@stusta.de> <20060724085701.B2083275@wobbly.melbourne.sgi.com> <200607242031.11815.a.gruenbacher@computer.org>
In-Reply-To: <200607242031.11815.a.gruenbacher@computer.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Gruenbacher wrote:
> On Monday, 24 July 2006 00:57, Nathan Scott wrote:
>> On Sun, Jul 23, 2006 at 08:43:43PM +0200, Adrian Bunk wrote:
>>> Hi,
>>>
>>> how much of include/linux/xattr.h has to be part of the userspace kernel
>>> headers?
>> None, I think.
> 
> None, indeed. The attr package comes with it own version of xattr.h that also 
> includes definitions of XATTR_CREATE and XATTR_REPLACE.
> 

However, it would be better if the ABI constants were exported, or at 
least *exportable* (using a __KERNEL_XATTR_MACROS test macro or 
something like that.)

	-hpa
