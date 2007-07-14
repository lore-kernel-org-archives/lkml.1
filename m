Return-Path: <linux-kernel-owner+w=401wt.eu-S1763968AbXGNTqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763968AbXGNTqf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 15:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761136AbXGNTq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 15:46:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58387 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759847AbXGNTq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 15:46:28 -0400
Date: Sat, 14 Jul 2007 21:46:12 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3][try 1] init: enable system-on-initramfs
In-Reply-To: <469919D5.3070709@zytor.com>
Message-ID: <Pine.LNX.4.58.0707142141030.2346@be1.lrz>
References: <Pine.LNX.4.58.0707132039080.3222@be1.lrz> <4697D6EB.5020404@zytor.com>
 <Pine.LNX.4.58.0707132344140.13842@be1.lrz> <469801B7.7010909@zytor.com>
 <Pine.LNX.4.58.0707141629510.5288@be1.lrz> <469919D5.3070709@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18UfTeHkhw66LOCN3W6630ECoP+qXiEekXDnzv
 zGEJoEi7fdjiLfDHh5ytE6v8MJiFI6tPOACIoSB+tu9Pk+Q0YX
 EW8sdRjVxT7KGtNuqxgUQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2007, H. Peter Anvin wrote:
> Bodo Eggert wrote:

> > Setting the name of the rdinit process to the name of the init process
> > in order to select the root device should not be the right knob.
> > 
> 
> What's wrong with it?

rdinit is supposed to be the program that mounts, root is supposed to be 
whatever is mounted and init is supposed to run the system. Three 
different things. Now if you want to change the third, just set the first 
to the second ...

-- 
Whenever you have plenty of ammo, you never miss. Whenever you are low on
ammo, you can't hit the broad side of a barn.
