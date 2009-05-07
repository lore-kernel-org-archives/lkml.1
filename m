Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbZEGIqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbZEGIqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbZEGIqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:46:19 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:23201 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbZEGIqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:46:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=DEXQ56feQ2sCwG2+5a8DqBulX+C5rJgmXCwD4pbplyNTuYgkR0Iyv0HDjANctMAYlz
         hq2Tb0pcNlceFBTDxKiDy0RnIZLJfzLGj8AaU1Q2jg7MxBKPbppgkZw+D0wKsSVXjsnZ
         SbNdo4Z6P4iH4I+iz/2/CYfdtDQvEbHRvmX+g=
Message-ID: <4A029FD1.1050007@gmail.com>
Date: Thu, 07 May 2009 10:46:09 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.7 Thunderbird/3.0b2
MIME-Version: 1.0
To: Yang Hongyang <yanghy@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] remove DMA_nBIT_MASK macro
References: <20090507141114M.fujita.tomonori@lab.ntt.co.jp> <20090506223452.65e545d8.akpm@linux-foundation.org> <4A029BE1.4090309@cn.fujitsu.com>
In-Reply-To: <4A029BE1.4090309@cn.fujitsu.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2009 10:29 AM, Yang Hongyang wrote:
> Shall we use something like below to warn people?
> #define DMA_64BIT_MASK	DMA_BIT_MASK(64);(__deprecated warnings:use DMA_BIT_MASK(64) instead) ?

Something like an irq flags deprecation in the past:
http://lwn.net/Articles/229673/
?

I don't know how many in-initializer (struct x x = { DMA_64BIT_MASK } )
users are out there though.
