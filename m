Return-Path: <linux-kernel-owner+w=401wt.eu-S1761479AbZFPSdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761479AbZFPSdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761302AbZFPSd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:33:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60578 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761292AbZFPSd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:33:26 -0400
Message-ID: <4A37B725.8070203@zytor.com>
Date: Tue, 16 Jun 2009 08:15:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Amerigo Wang <xiyou.wangcong@gmail.com>
CC: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [x86] Build error at arch/x86/boot/bioscall.S
References: <200906160738.n5G7cs9r007216@www262.sakura.ne.jp> <20090616081445.GB6270@cr0.nay.redhat.com> <200906160825.n5G8PYRu020230@www262.sakura.ne.jp> <20090616093056.GD6270@cr0.nay.redhat.com>
In-Reply-To: <20090616093056.GD6270@cr0.nay.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang wrote:
> 
> Ok, how about:
> 
> - movw 68(%esp), %di
> + addl $68, %esp
> + popw %di
> + subl $66, %esp
> 

This will destroy the stack if an untimely interrupt shows up.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

