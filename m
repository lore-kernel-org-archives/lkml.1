Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZCKOUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZCKOUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbZCKOUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:20:20 -0400
Received: from ottmail.xandros.com ([142.46.212.35]:57430 "EHLO
	ottmail.xandros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbZCKOUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:20:18 -0400
Date: Wed, 11 Mar 2009 10:14:01 -0400
From: Woody Suwalski <woodys@xandros.com>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Message-ID: <49B7C729.5080301@xandros.com>
In-Reply-To: <49B703D4.1000008@zytor.com>
References: <49B703D4.1000008@zytor.com>
Subject: Re: x86: removing zImage support?
x-scalix-Hops: 1
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> I'm thinking again about removing zImage support.  An "allnoconfig"
> kernel (with CONFIG_EMBEDDED=y to expose additional knobs, and
> CONFIG_BINFMT_ELF=y so it can do anything at all) is currently 487K on
> i386 -- very close to the upper limit of 512K for zImage.
>
> Are there *any* residual users of this, or should I just push a patch to
> remove it once and for all?
>
> 	-hpa
>
>   
If x86-only - OK.

However zImage is the format used on ARM quite often... So any "kernel complexity removal" need to happen only on x86 side.


Woody

-- 
Woody Suwalski, Xandros, Ottawa, Canada, 1-613-842-3498 x414

