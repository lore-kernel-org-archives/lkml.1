Return-Path: <linux-kernel-owner+w=401wt.eu-S1761005AbXLOLol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761005AbXLOLol (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 06:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbXLOLod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 06:44:33 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:54709 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbXLOLoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 06:44:32 -0500
Date: Sat, 15 Dec 2007 12:44:31 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.24-rc5-mm1] Why CONFIG_BLK_DEV_RAM=m makes \\\"#ifdef
 CONFIG_BLK_DEV_RAM\\\" false?
In-Reply-To: <200712140615.lBE6FX4b058136@www262.sakura.ne.jp>
Message-ID: <Pine.LNX.4.64.0712151242340.22877@fbirervta.pbzchgretzou.qr>
References: <200712140504.lBE54Jpa044093@www262.sakura.ne.jp>
 <20071213214509.f27c2717.randy.dunlap@oracle.com>
 <200712140615.lBE6FX4b058136@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 14 2007 15:15, Tetsuo Handa wrote:
>Hello.
>
>Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> I don't think that this is a change from the recent past.
>
>Oh, it is my mistake.
>
>I found that choosing CONFIG_BLK_DEV_RAM=m makes
>impossible to pass an initrd image since
>populate_rootfs() in init/initramfs.c omits
>code for checking whether the image is an initrd or not.

I believe it is (also?) due to /dev/ram0 not being available
where the initrd usually gets copied into.

initramfs continues to work, and that is what should I think
should be used for any new projects.

>But I didn't know CONFIG_BLK_DEV_RAM is tristate.
>So, I have to change to CONFIG_BLK_DEV_RAM=y when
>I want to pass an initrd image after "make allmodconfig".
