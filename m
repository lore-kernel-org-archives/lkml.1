Return-Path: <linux-kernel-owner+w=401wt.eu-S934509AbXFFQAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934509AbXFFQAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbXFFQAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:00:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:32670 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbXFFQAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:00:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:openpgp:content-type:content-transfer-encoding;
        b=p93F/KxJTRuEeYGSoBkDljVwazR7nuZEcc/gF4G1OYLfRW9sxZivMMPPP9UVE9i5+bDSRwftcDu/HTCypIk8w/86u8iqg3G7ZwkyciPyxVmoFCLmMj5T4260DOJMZSgQYBVEmrNVPcV8yy1HlAafUseX0eU6OzHmj/2E3crr+aE=
Message-ID: <4666D9FC.8030002@gmail.com>
Date: Wed, 06 Jun 2007 21:29:56 +0530
From: jimmy bahuleyan <knight.camelot@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Size of kernel modules
References: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de>
In-Reply-To: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de>
X-Enigmail-Version: 0.95.0
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Pleger wrote:
> Hello,
> 
[snip]
> After the new kernel package had been created, I installed it. After
> that, I looked into the directory /boot and was very surprised: The
> initial ramdisk of the new kernel was much larger than the initrd of the
> old kernel. To find out the cause for this, I investigated how
> directories /lib/modules/$old and /lib/modules/$new differ. I found out
> that the filenames are the same, but the size of the files differs very
> much. I found a module file in the new directory that was almost five
> times as large as the file with the same name in the old directory.
> 

sounds more like you have debug options enabled?

-jb
-- 
Tact is the art of making a point without making an enemy.
