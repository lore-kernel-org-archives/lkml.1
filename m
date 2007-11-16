Return-Path: <linux-kernel-owner+w=401wt.eu-S1765047AbXKPSUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765047AbXKPSUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762924AbXKPSU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:20:29 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:56545 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762710AbXKPSU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:20:27 -0500
To: trond.myklebust@fys.uio.no
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [TOMOYO #5 02/18] Add wrapper functions for VFS helperfunctions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20071116173439.796600895@I-love.SAKURA.ne.jp>
	<20071116173524.195366292@I-love.SAKURA.ne.jp>
	<1195235255.7653.69.camel@heimdal.trondhjem.org>
In-Reply-To: <1195235255.7653.69.camel@heimdal.trondhjem.org>
Message-Id: <200711170320.GCD21875.OSVJFOHtMQFFLO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 17 Nov 2007 03:20:22 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Trond Myklebust wrote:
> > This patch allows LSM hooks refer previously associated "struct vfsmount" parameter
> > so that they can calculate pathname of given "struct dentry".
> 
> NACK to this. Passing function parameters through the task_struct is
> definitely not an acceptable hack (unless you're doing it through the
> stack).

Thanks for your advise.
But I don't know why it is not acceptable.
The topmost vfsmount's address is retrievable through the task_struct,
and non-topmost vfsmount's address (if any) are stored on the stack memory.
Could you show me why this is bad?

Regards.

