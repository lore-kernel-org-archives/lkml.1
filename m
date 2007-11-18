Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbXKRXu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbXKRXu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 18:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbXKRXuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 18:50:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:58056 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbXKRXut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 18:50:49 -0500
Date: Mon, 19 Nov 2007 00:50:27 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: 7eggert@gmx.de, Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH][retry-2] init: Introduce rootdir bootparm to select
 which dir to sys_chroot
In-Reply-To: <47409A48.3000409@zytor.com>
Message-ID: <alpine.LSU.0.999.0711190042340.14144@be1.lrz>
References: <9qVOO-4ZK-13@gated-at.bofh.it> <E1ItqCg-0003W2-Qu@be1.7eggert.dyndns.org>
 <47409A48.3000409@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19ZQ3qnlKi1IeQ1UlFqYnnEbA56S1S+g7hYB+t
 bkki/9BxTiapeQbavIjroQDgXYyD+F1OCZ9u1oq9ZPeIMXzQpy
 SQd1FlgUCaoA9DKTEQ+Xg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Nov 2007, H. Peter Anvin wrote:
> Bodo Eggert wrote:

>> 1) This is useful for booting a rescue or test system, too. In those cases,
>>    you might want to have the old root moved somewhere.
>>    (Always "$rootdir/oldroot"? Additional parameter? I'm not sure ...)
>> 
>
> Again, this is a good example of why this really shouldn't be additional 
> hacks in kernel space.

ACK, but until kinit is default (and Godot arrives), this little hack does 
seem to be useful.

-- 
Top 100 things you don't want the sysadmin to say:
63. Oracle will be down until 8pm, but you can come back in and finish your
    work when it comes up tonight.
