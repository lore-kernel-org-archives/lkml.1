Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbXKHAQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbXKHAQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 19:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbXKHAQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 19:16:26 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:51134 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbXKHAQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 19:16:24 -0500
Message-Id: <200711080014.lA80EvJB088704@www262.sakura.ne.jp>
Subject: Re: Problem with accessing namespace_sem from LSM.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: hch@infradead.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, crispin@crispincowan.com
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Nov 2007 09:14:57 +0900
References: <200711060400.lA640fuE078356@www262.sakura.ne.jp> <20071106133559.GA13366@infradead.org> <200711062352.CIJ34385.LSOHJFOVFFOtMQ@I-love.SAKURA.ne.jp> <20071107173039.GA25560@infradead.org> <200711080704.CHC65673.OOtFJFFSHQVOML@I-love.SAKURA.ne.jp> <20071107224523.GA8223@infradead.org>
In-Reply-To: <20071107224523.GA8223@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Christoph Hellwig wrote:
> Same argument as with the AA folks: it does not have any business looking
> at the vfsmount.  If you create a file it can and in many setups will
> show up in multiple vfsmounts, so making decisions based on the particular
> one this creat happens through is wrong and actually dangerous.
Thus TOMOYO 1.x doesn't use LSM hooks, and AppArmor for OpenSuSE 10.3
added "struct vfsmount" parameter for VFS helper functions and LSM hooks.

Not all systems use bind mounts.
There is likely only one vfsmount which corresponds with a given dentry.

What does "dangerous" mean? It causes crash?

Regards.
