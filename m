Return-Path: <linux-kernel-owner+w=401wt.eu-S1763519AbXKPRrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763519AbXKPRrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757917AbXKPRrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:47:36 -0500
Received: from pat.uio.no ([129.240.10.15]:39669 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950AbXKPRre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:47:34 -0500
Subject: Re: [TOMOYO #5 02/18] Add wrapper functions for VFS helper
	functions.
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: penguin-kernel@I-love.SAKURA.ne.jp
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <20071116173524.195366292@I-love.SAKURA.ne.jp>
References: <20071116173439.796600895@I-love.SAKURA.ne.jp>
	 <20071116173524.195366292@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 12:47:35 -0500
Message-Id: <1195235255.7653.69.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.2, required=12.0, autolearn=disabled, AWL=-0.191)
X-UiO-Scanned: DC0D362F728D089833747C1B131A0BB05B860920
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -1 maxlevel 200 minaction 2 bait 0 mail/h: 584 total 5185169 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-11-17 at 02:34 +0900, penguin-kernel@I-love.SAKURA.ne.jp
wrote:
> plain text document attachment
> (add-wrapper-functions-for-vfs-helper-functions.patch)
> This patch allows LSM hooks refer previously associated "struct vfsmount" parameter
> so that they can calculate pathname of given "struct dentry".

NACK to this. Passing function parameters through the task_struct is
definitely not an acceptable hack (unless you're doing it through the
stack).

Trond

