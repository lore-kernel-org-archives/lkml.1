Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbZFPIZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbZFPIZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbZFPIZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:25:37 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63775 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbZFPIZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:25:36 -0400
Message-Id: <200906160825.n5G8PYRu020230@www262.sakura.ne.jp>
Subject: Re: [x86] Build error at arch/x86/boot/bioscall.S
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: xiyou.wangcong@gmail.com
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 16 Jun 2009 17:25:34 +0900
References: <200906160738.n5G7cs9r007216@www262.sakura.ne.jp> <20090616081445.GB6270@cr0.nay.redhat.com>
In-Reply-To: <20090616081445.GB6270@cr0.nay.redhat.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 16062009 #2124512, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang wrote:
> How about:
> 
> - movw 68(%esp), %di
> + movzwl %sp, %ebx
> + movw 68(%ebx), %di
> 
> ? Does this work?
No.

arch/x86/boot/bioscall.S: Assembler messages:
arch/x86/boot/bioscall.S:69: Error: `68(%ebx)' is not a valid 16 bit base/index expression
make[1]: *** [arch/x86/boot/bioscall.o] Error 1
make: *** [bzImage] Error 2

Regards.
