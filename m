Return-Path: <linux-kernel-owner+w=401wt.eu-S1760177AbXLNGQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177AbXLNGQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 01:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbXLNGQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 01:16:00 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:50785 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbXLNGP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 01:15:57 -0500
Message-Id: <200712140615.lBE6FX4b058136@www262.sakura.ne.jp>
Subject: Re: [2.6.24-rc5-mm1] Why CONFIG_BLK_DEV_RAM=m makes \\\"#ifdef CONFIG_BLK_DEV_RAM\\\" false?
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Dec 2007 15:15:32 +0900
References: <200712140504.lBE54Jpa044093@www262.sakura.ne.jp> <20071213214509.f27c2717.randy.dunlap@oracle.com>
In-Reply-To: <20071213214509.f27c2717.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Randy Dunlap <randy.dunlap@oracle.com> wrote:
> I don't think that this is a change from the recent past.

Oh, it is my mistake.

I found that choosing CONFIG_BLK_DEV_RAM=m makes
impossible to pass an initrd image since
populate_rootfs() in init/initramfs.c omits
code for checking whether the image is an initrd or not.
But I didn't know CONFIG_BLK_DEV_RAM is tristate.
So, I have to change to CONFIG_BLK_DEV_RAM=y when
I want to pass an initrd image after "make allmodconfig".

Thank you.
