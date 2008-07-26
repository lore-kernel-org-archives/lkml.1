Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbYGZSVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbYGZSVw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 14:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbYGZSVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 14:21:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42885 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbYGZSVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 14:21:43 -0400
Message-ID: <488B6A5F.8000706@zytor.com>
Date: Sat, 26 Jul 2008 14:18:07 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Harvey Harrison <harvey.harrison@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: asm-x86/byteorder.h, CONFIG_X86_BSWAP leaks to userland
References: <20080726013931.bcc4682d.akpm@linux-foundation.org>	<1217090446.5971.57.camel@brick>	<488B555F.4090709@zytor.com> <20080726095901.4a06daf9@infradead.org>
In-Reply-To: <20080726095901.4a06daf9@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
\>
> It is also not the kernels job to provide this sort of functionality to
> userspace programs. At all. This is gcc/glibc/etc's job.
> 
> Rule of thumb: the kernel does not provide code for compiling inside
> userspace programs.
> 
> (As opposed to providing datastructures that userspace programs can use
> to talk to the kernel).
> 

That's a fine rule of thumb, but we have 17 years of legacy to deal with 
here, too.

	-hpa

