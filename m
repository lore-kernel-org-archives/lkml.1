Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbXKFOw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbXKFOw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 09:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbXKFOwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 09:52:49 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:60171 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbXKFOws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 09:52:48 -0500
To: hch@infradead.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, crispin@crispincowan.com
Subject: Re: Problem with accessing namespace_sem from LSM.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200711060400.lA640fuE078356@www262.sakura.ne.jp>
	<20071106133559.GA13366@infradead.org>
In-Reply-To: <20071106133559.GA13366@infradead.org>
Message-Id: <200711062352.CIJ34385.LSOHJFOVFFOtMQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 6 Nov 2007 23:52:40 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Christoph Hellwig wrote:
> Any code except VFS internals has no business using it at all and doesn't
> do that in mainline either.  I'd start looking for design bugs in whatever
> code you have using it first.
Isn't security_inode_create() a part of VFS internals?
I think security_inode_create() is a part of VFS internals
because it is called from vfs_create().

Regards.

