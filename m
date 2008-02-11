Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYBKKU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYBKKU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYBKKUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:20:50 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:12623 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYBKKUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:20:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XKe++Aa4VD2Vdfpfvi27KMWVY/JUZ3cHZrU1FicDPLe9bqPrv227egL8+A5pvo85STemC6BqUHALOgrJrBxms+bLdjvC6A2yorO0bwJtbu0d1KykZC23YqCRTOhBuu2qhmYkJ88f0OBK8hSRIS/GtEh32LCxGG6llUMAk2h2ttc=
Message-ID: <2f11576a0802110220g459d7390je05bfec161e6768e@mail.gmail.com>
Date: Mon, 11 Feb 2008 19:20:47 +0900
From: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
To: "Eugene Teo" <eugeneteo@kernel.sg>
Subject: Re: [PATCH] proc: extend /proc/<pid>/fdinfo/<fd>
Cc: linux-kernel@vger.kernel.org, "Miklos Szeredi" <mszeredi@suse.cz>
In-Reply-To: <20080209120157.GA3035@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080209120157.GA3035@kernel.sg>
X-Google-Sender-Auth: 53f458c12d0aa0ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eugene

In general, I think this patch isn't wrong idea.
but it shuld be brush up more, may be.

> kerndev: ~/code/kernel# cat /proc/`pgrep pickup`/fdinfo/6
> mode:   0622

I think this is inode attribute, but not fd attribute.

> dev:    253,0
> ino:    21463057

may be useful, agreed with you :)

> uid:    89
> gid:    89
> rdev:   0,0
> pos:    0
> flags:  04002 FD_CLOEXEC # if close-on-exec flag is set

agreed with Miklos's opinion.

> path:   /var/spool/postfix/public/pickup

may be, we shold think namespace..

> You can also use this to find out more information about locked open files:

is your requirement only fd -> ino pick up?
