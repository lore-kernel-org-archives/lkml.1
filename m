Return-Path: <linux-kernel-owner+w=401wt.eu-S965338AbXC0UOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965338AbXC0UOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 16:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965345AbXC0UOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 16:14:45 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:48179 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965338AbXC0UOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 16:14:44 -0400
Message-ID: <46097B27.6090606@namesys.com>
Date: Wed, 28 Mar 2007 00:14:31 +0400
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ignatich <ignatich@gmail.com>
CC: reiserfs-list@namesys.com, linux-kernel@vger.kernel.org,
       Jonathan Briggs <jbriggs@esoft.com>
Subject: Re: [Fwd: reiser4 bugs in 2.6.21-rc4]
References: <460974EE.8080006@gmail.com>
In-Reply-To: <460974EE.8080006@gmail.com>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ignatich wrote:

>
>
> ------------------------------------------------------------------------
>
> Subject:
> reiser4 bugs in 2.6.21-rc4
> From:
> Ignatich <ignatich@gmail.com>
> Date:
> Tue, 27 Mar 2007 23:29:18 +0400
> To:
> linux-kernel@vger.kernel.org
>
> To:
> linux-kernel@vger.kernel.org
>
> Message-ID:
> <4609708E.5090908@gmail.com>
> User-Agent:
> Thunderbird 1.5.0.10 (Windows/20070221)
> MIME-Version:
> 1.0
> Content-Type:
> text/plain; charset=windows-1251; format=flowed
> Content-Transfer-Encoding:
> 7bit
>
>
> There are two bugs I found in current -mm reiser4 code.
>
> 1. Some files seem to be zeroed out randomly. Usually it's 
> /lib/security/pam_limits.so and /lib/security/pam_deny.so. As 
> fsck.reiser4 didn't find anything wrong I decided to create clean 
> installation in vmware and see if this bug appears on newly formatted 
> partition. It did.
>
> 2. Sometimes I get oppses in reiser4_do_readpage_extent. Assert codes 
> are vs-1426 and nikita-2688. A patch was posted on namesys list to 
> address this problem, but it didn't help.
>
> Kernel: 2.6.21-rc4 with manually applied reiser4 patches from -mm. 
> Arch: x86-64
>

We are working on this.
Thanks for reports,

Edward.

