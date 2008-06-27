Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYF0CAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYF0CAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 22:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbYF0CAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 22:00:05 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:17429 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYF0CAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 22:00:04 -0400
Date: Thu, 26 Jun 2008 19:58:15 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: LZMA compression algorithm in Kernel - any chance to allow it?
In-reply-to: <fa.WuwHJZhCHgER6Pu+gn66zdRwVUg@ifi.uio.no>
To: Tomas M <tomas@slax.org>
Cc: linux-kernel@vger.kernel.org
Message-id: <48644937.3050503@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.WuwHJZhCHgER6Pu+gn66zdRwVUg@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas M wrote:
> Hello.
> I can see the 2.6.25 kernel includes LZO compression algorithm in:
> 
> [*] Cryptographic API
>  < > LZO compression algorithm
> 
> As far as I could see, there was a strong pressure against putting compression algorithms in kernel. Does this LZO example mean that kernel people are now more open to include other algorithms as well? I'd like to include LZMA algo, which has far better compression ratio then anything else widely used today, and is already used in many small or embeded systems (as external patches to kernel or userspace utilities)
> 
> If I (or anybody else) submit LZMA code for inclusion in kernel, would you ACCEPT IT ?? (assuming the code looks nice to you)

Not if there is nothing that uses it. If you have a place in the kernel 
that could make good use of such compression, which couldn't easily be 
handled outside the kernel, and you update it to use it, I would guess 
it would likely be accepted.
