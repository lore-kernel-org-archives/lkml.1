Return-Path: <linux-kernel-owner+w=401wt.eu-S932133AbXIIO0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbXIIO0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 10:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbXIIO02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 10:26:28 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:43619 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401AbXIIO01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 10:26:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=skfqaR+wJCosf8c9bIGR/rPXoqr9z568Lfv7oDAUyHa/hx8gogq/9mg2pSmK4HQC/VbADKRqm88iihK/YMSTJRb947gt6P5SfQ/gQhG4qVtdT3/vUyBJzZui8m0kpg+IPEsvwnKR2IDw/aDuuLhpvu91m8me5vtD93xyhFOMzS0=
Message-ID: <46E4028E.9050007@gmail.com>
Date: Sun, 09 Sep 2007 16:26:22 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, airlied@linux.ie
Subject: Re: X freezes kernel during exit [Re: 2.6.23-rc3-mm1]
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46D17A7A.70609@gmail.com> <46D409FC.1070305@gmail.com> <46E3DCB8.5010709@gmail.com> <20070909054751.cbb27081.akpm@linux-foundation.org> <46E3FE6B.7010209@gmail.com> <20070909141730.GB25798@one.firstfloor.org>
In-Reply-To: <20070909141730.GB25798@one.firstfloor.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2007 04:17 PM, Andi Kleen wrote:
>> Hm, I suspect Andi's x86_64-mm-cpa-clflush.patch or something like that. It
>> loops in flush_kernel_map in list_for_each_entry on the first CPU. The a->l list
>> is somehow corrupted I guess.
> 
> Does it still happen with the latest version 

I think so :)
$ diff -u x86_64-mm-cpa-clflush.patch cpa-clflush |wc -l
0

> ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/cpa-clflush
> 
> ?
> 
> (you might need to replace the other cpa-* patches too because
> they depend on each other) 

And are there any changes against the -rc4-mm1 in those patches?

BTW it is reproducible for me on two different machines (i386-x86_64,
radeon-intel), don't you have the problem too?

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
