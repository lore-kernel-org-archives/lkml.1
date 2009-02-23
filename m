Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbZBWIcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbZBWIcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 03:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbZBWIca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 03:32:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51022 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbZBWIc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 03:32:29 -0500
Message-ID: <49A25F30.9060305@cn.fujitsu.com>
Date: Mon, 23 Feb 2009 16:32:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Paul Jackson <pj@sgi.com>, Simon Derr <simon.derr@bull.net>,
       Paul Menage <menage@google.com>
Subject: Re: [PATCH] Remove some pointless conditionals before kfree() in
 kernel/cgroup.c
References: <alpine.LNX.2.00.0902222254350.1236@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.0902222254350.1236@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> Hi,
> 
> Here's a small patch for kernel/cgroup.c
> 
> Removes a few pointless tests of pointer == 0 before kfree() in 
> kernel/cgroup.c.
> If the pointer we hand to kfree() is 0, then kfree() is a noop, so there 
> is no need to test.
> 
> Reduces object file size a bit : 
> 
> Before:
> $ size kernel/cgroup.o
>    text    data     bss     dec     hex filename
>   21593    7804    4924   34321    8611 kernel/cgroup.o
> After:
> $ size kernel/cgroup.o
>    text    data     bss     dec     hex filename
>   21537    7744    4924   34205    859d kernel/cgroup.o
> 
> and source file size shrinks a bit too - always nice.
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>


