Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbXKRUCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbXKRUCf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 15:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbXKRUC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 15:02:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57067 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbXKRUC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 15:02:27 -0500
Message-ID: <47409A48.3000409@zytor.com>
Date: Sun, 18 Nov 2007 12:02:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH][retry-2] init: Introduce rootdir bootparm to select which
 dir to sys_chroot
References: <9qVOO-4ZK-13@gated-at.bofh.it> <E1ItqCg-0003W2-Qu@be1.7eggert.dyndns.org>
In-Reply-To: <E1ItqCg-0003W2-Qu@be1.7eggert.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> 
> 1) This is useful for booting a rescue or test system, too. In those cases,
>    you might want to have the old root moved somewhere.
>    (Always "$rootdir/oldroot"? Additional parameter? I'm not sure ...)
> 

Again, this is a good example of why this really shouldn't be additional 
hacks in kernel space.

	-hpa
