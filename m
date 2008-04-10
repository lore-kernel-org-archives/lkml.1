Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbYDJM5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbYDJM5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 08:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbYDJM4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 08:56:55 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54374 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbYDJM4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:56:54 -0400
To: penguin-kernel@I-love.SAKURA.ne.jp
CC: viro@zeniv.linux.org.uk, miklos@szeredi.hu, ezk@cs.sunysb.edu,
       akpm@linux-foundation.org, dave@linux.vnet.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <200804102102.JFI05247.OVJOFHFStLOFQM@I-love.SAKURA.ne.jp>
	(message from Tetsuo Handa on Thu, 10 Apr 2008 21:02:57 +0900)
Subject: Re: [PATCH] Call LSM functions outside VFS helper functions.
References: <200804090053.m390rE9k007085@agora.fsl.cs.sunysb.edu>
	<E1Jjug8-0006a2-Vs@pomaz-ex.szeredi.hu> <200804102102.JFI05247.OVJOFHFStLOFQM@I-love.SAKURA.ne.jp>
Message-Id: <E1JjwK1-0006ml-6c@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 10 Apr 2008 14:56:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I'm reading this thread on tenterhooks.
> If vfsmount is passed to VFS helper functions, that will make
> r/o bind mounts and AppArmor and TOMOYO Linux happy.
> But so far, it seems that "passing vfsmount makes things complicated".

If done right, it shouldn't.  At least it didn't seem to complicate
the parts that I've touched ;)

> If the conclusion became "vfsmount should not be passed to
> VFS helper functions", that's OK, but I want you to consider
> the below approach for AppArmor and TOMOYO Linux. This patch is a repost of
> http://kerneltrap.org/mailarchive/linux-fsdevel/2008/2/17/882024 .

I'm not a big fan of adding new security hooks.  Nor of moving the
existing ones to callers.

Miklos
