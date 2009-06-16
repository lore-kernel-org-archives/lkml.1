Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbZFPLkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbZFPLkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 07:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZFPLkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 07:40:32 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:59179 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbZFPLkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 07:40:32 -0400
To: xiyou.wangcong@gmail.com
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [x86] Build error at arch/x86/boot/bioscall.S
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200906160738.n5G7cs9r007216@www262.sakura.ne.jp>
	<20090616081445.GB6270@cr0.nay.redhat.com>
	<200906160825.n5G8PYRu020230@www262.sakura.ne.jp>
	<20090616093056.GD6270@cr0.nay.redhat.com>
In-Reply-To: <20090616093056.GD6270@cr0.nay.redhat.com>
Message-Id: <200906162040.GGD82870.SLFtOFVQHOJOMF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 16 Jun 2009 20:40:32 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang wrote:
> Ok, how about:
> 
> - movw 68(%esp), %di
> + addl $68, %esp
> + popw %di
> + subl $66, %esp
> 
> ?
Yes, that works.

Thank you.
