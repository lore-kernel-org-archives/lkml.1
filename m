Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbXFKGQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbXFKGQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 02:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbXFKGPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 02:15:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:10526 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbXFKGPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 02:15:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=eYpLDjGQQpNhi1FMhU7cdoeY+fX79+ab6WpUq0zzI9Q//YnXl8MHDW31RBzzAWzOCietVwYzHiP5EAzBLLpY7Xn5gDqEsUexxSfWYAlwVdBM/eBroYT2k9UhmVoV34+sMD/S/yjQmoNw6sykhLc1O3+qGOaGL44bb6fDK+XBRuI=
Message-ID: <466CE88B.2050803@gmail.com>
Date: Mon, 11 Jun 2007 15:15:39 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, greg@kroah.com, cebbert@redhat.com,
       sandeen@redhat.com, maneesh@in.ibm.com, cs@tequila.co.jp
Subject: Re: [PATCHSET 2.6.22-rc4] sysfs: fix race conditions
References: <20070611050107.GJ29122@htj.dyndns.org> <20070610231203.730d0aba.akpm@linux-foundation.org>
In-Reply-To: <20070610231203.730d0aba.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> This patchset contains three minimal backports of fixes in -mm.  With
>> all patches in the patchset and sysfs-races.patch applied, kernel
>> survived ~20 hours of stress test without any problem.
> 
> So these are being proposed for 2.6.22?

Yeap.

> I do wonder about Rafael's bug which he bisected down to
> gregkh-driver-sysfs-use-singly-linked-list-for-sysfs_dirent-tree.patch.
> 
> If that won't be a problem in this patchset then I spose it's probably best
> to go ahead with a 2.6.22 merge, but it's more a Greg thing than a me
> thing.

I'm currently debugging that and it's irrelevant to these fixes.  The
bug is introduced far after the fixes.

> I don't have a tree to merge these patches into, unless I drop all the
> patches which are in Greg's tree.
> 
> Greg, can I leave it up to you to decide how we are to proceed here?

I can rebase all sysfs patches in -mm on top of linus#master + these
fixes if necessary.

Thanks.

-- 
tejun
