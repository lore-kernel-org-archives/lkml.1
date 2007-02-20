Return-Path: <linux-kernel-owner+w=401wt.eu-S964794AbXBTGh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964794AbXBTGh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 01:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964791AbXBTGhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 01:37:47 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:21818 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964790AbXBTGhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 01:37:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=LP9r8ZbazCH3mJXuaaUY96CYD/ub9eY8SW4hCnK5FtbVaX5a9xMsXHcqG1MzW4UZnfn9YGTxFr0rtwDl/BlwyVGjkovwrqdsrwflqIKRKOu0DmsILK9O4AHYgIbN0n8cZxSGEZ0ppH/YEeUyDtAYXpuxs3IfjUlPgF0jR7agJpU=
Message-ID: <84144f020702192237k78a5045bl51e0871fb3cac253@mail.gmail.com>
Date: Tue, 20 Feb 2007 08:37:34 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [-mm patch] UNION_FS must depend on SLAB
Cc: "Andrew Morton" <akpm@linux-foundation.org>, jsipek@cs.sunysb.edu,
       linux-kernel@vger.kernel.org, unionfs@filesystems.org
In-Reply-To: <20070220000810.GK13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
	 <20070220000810.GK13958@stusta.de>
X-Google-Sender-Auth: 5e3eb703466ff66f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/20/07, Adrian Bunk <bunk@stusta.de> wrote:
>   CC      fs/unionfs/copyup.o
> /home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/fs/unionfs/copyup.c: In function 'create_parents_named':
> /home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/fs/unionfs/copyup.c:620: error: 'malloc_sizes' undeclared (first use in this function)
> /home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/fs/unionfs/copyup.c:620: error: (Each undeclared identifier is reported only once
> /home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/fs/unionfs/copyup.c:620: error: for each function it appears in.)
> make[3]: *** [fs/unionfs/copyup.o] Error 1

Hmm, why is unionfs playing around with malloc_sizes in the first place? Jeff?
