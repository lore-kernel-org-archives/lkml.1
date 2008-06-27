Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbYF0MVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbYF0MVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762019AbYF0MOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:14:24 -0400
Received: from ns1.bluetone.cz ([212.158.128.13]:59062 "EHLO ns1.bluetone.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762011AbYF0MOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:14:23 -0400
Message-ID: <4864D9AF.4030509@slax.org>
Date: Fri, 27 Jun 2008 14:14:39 +0200
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: LZMA compression algorithm in Kernel - any chance to allow it?
References: <48634BA7.6030902@slax.org> <20080626201754.GE9878@ucw.cz>
In-Reply-To: <20080626201754.GE9878@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I use LZMA particularly in squashfs, which is a replacement for cramfs at all.

Unfortunately even squashfs is not in kernel.



Tomas M


Pavel Machek wrote:
> On Thu 2008-06-26 09:56:23, Tomas M wrote:
>> Hello.
>> I can see the 2.6.25 kernel includes LZO compression algorithm in:
>>
>> [*] Cryptographic API
>>  < > LZO compression algorithm
>>
>> As far as I could see, there was a strong pressure against putting compression algorithms in kernel. Does this LZO example mean that kernel people are now more open to include other algorithms as well? I'd like to include LZMA algo, which has far better compression ratio then anything else widely used today, and is already used in many small or embeded systems (as external patches to kernel or userspace utilities)
>>
>> If I (or anybody else) submit LZMA code for inclusion in kernel, would you ACCEPT IT ?? (assuming the code looks nice to you)
> 
> You need some good reason why lzma should be in kernel... like 'cramfs
> can use it'...?
> 							Pavel

