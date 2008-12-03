Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbYLCPWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbYLCPWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 10:22:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYLCPWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 10:22:39 -0500
Received: from smtp.zeuux.org ([210.51.160.52]:53213 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbYLCPWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 10:22:39 -0500
Date: Wed, 3 Dec 2008 23:22:34 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>, mingo@redhat.com
Subject: Re: v2.6.28-rc7: Fail compile arch/x86/kernel/cpu/common.c
Message-ID: <20081203152234.GA6924@ubuntu>
References: <20081203070115.GA32403@ubuntu> <20081203073504.GB17580@elte.hu> <20081203112725.GA6822@ubuntu> <20081203114748.GB19664@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081203114748.GB19664@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 12:47:48PM +0100, Ingo Molnar wrote:
>* Jianjun Kong <jianjun@zeuux.org> wrote:

>> >> arch/x86/kernel/cpu/common.c: In function ‘early_identify_cpu’:
>> >> arch/x86/kernel/cpu/common.c:555: error: ‘boot_cpu_id’ undeclared (first
>> >> use in this function)
>
>the error message is not consistent with what the code does:

<....>
>how can this not build? Do you have __ASSEMBLY__ defined in your CFLAGS 
>perhaps?

When I compile the code with another system(Fedora).There is another error
"include/asm is a directory but a symlink was expected". I think there maybe a file problem :<

So I remove the include directory, and update the code. Then I can compile it rightly :)

Sorry for disturbande.

-- 
Jianjun Kong | Happy Hacking
HOMEPAGE: http://kongove.cn/
GTALK: kongjianjun@gmail.com
