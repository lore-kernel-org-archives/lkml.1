Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYAACRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYAACRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 21:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYAACRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 21:17:03 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:50973 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbYAACRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 21:17:01 -0500
To: serue@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200712232344.JBJ90661.FQOFtFOVLJHSOM@I-love.SAKURA.ne.jp>
	<20071231200247.GA30373@sergelap.austin.ibm.com>
In-Reply-To: <20071231200247.GA30373@sergelap.austin.ibm.com>
Message-Id: <200801011116.AFH73928.MHFLtOSOOVJFQF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 1 Jan 2008 11:16:55 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Thank you for reviewing.

Serge E. Hallyn wrote:
> > This time, I'm implementing this filesystem as an extension to tmpfs
> > because what this filesystem does are nothing but check filename and
> > its attributes in addition to what tmpfs does.
> 
> To integrate this nicer into tmpfs, at least define TMPFS_IS_MAC as 1
> and TMPFS_NOT_MAC as 0 and pass those values instead of just 1 and 0.
> 
Question to everybody:
  Not all users need this extension, so I'm worrying that integrating
  this extension into tmpfs increases memory usage needlessly.
  May I implement this filesystem as an extension to tmpfs
  provided that users can enable/disable this extension via kernel config?

> Again, I should think you'd actually want to take blkdev_open() from
> fs/block_dev.c and chrdev_open() from fs/char_dev.c.  Surely your
> method of grabbing it here is not acceptable for upstream code.
I see.

Regards.
