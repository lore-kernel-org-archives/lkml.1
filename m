Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbYJDLQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbYJDLQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 07:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYJDLQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 07:16:01 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:58910 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbYJDLQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 07:16:00 -0400
To: dhowells@redhat.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRED: ptrace_attach() should use the target process\'s mutex
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200810030356.m933uYeX005874@www262.sakura.ne.jp><200810012000.CGG73421.FQOHtLOJFVMOSF@I-love.SAKURA.ne.jp><20081001153823.9930.86648.stgit@warthog.procyon.org.uk><200810021952.GFJ87098.VQFtMOHJOFFLSO@I-love.SAKURA.ne.jp><25964.1223048004@redhat.com>
In-Reply-To: <25964.1223048004@redhat.com>
Message-Id: <200810042015.IFH86706.OFQFSFLJOtMHOV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 4 Oct 2008 20:15:54 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

David Howells wrote:
> 
> Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:
> 
> > Subject: Add in_execve flag into task_struct.
> > 
> > This patch allows LSM modules determine whether current process is in an
> > execve operation or not so that they can behave differently while an execve
> > operation is in progress.
> 
> This doesn't apply on top of my patches.  How about the attached variant?

Yes. Behavior will be the same.

> I've also:
> 
>  (1) Extended the patch description.  Please check that I've summed up TOMOYA's
>      process correctly.

Description is correct. But please apply "sed -e 's/TOMOYA/TOMOYO/g'".
TOMOYO Linux was introduced as TOMOYA Linux by mistake at OLS2008.
The origin of the name is at http://I-love.SAKURA.ne.jp/tomoyo/index.html.en :-)

>  (2) Used current directly rather than caching it in a variable.  I don't
>      think it's worth doing that, given the amount you make use of it, but I
>      can revert this change if you'd really prefer.

OK.

Please proceed. Thanks.
