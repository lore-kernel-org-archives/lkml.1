Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbXLDMGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbXLDMGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbXLDMGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:06:32 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:40823 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbXLDMGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:06:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=i9tGTCmpcfIOXVxYprXGxtPJ41CFMJZcBiAfDCaKPEbl7dgP6ZUwzaPTr5C3cNCNlBrHFAcHDswZiaadV0rYqxO4bLVw8kDfM1+zisf7RBbtgiNHx2jQZTp8EVdm4KV4Z0ZJdN/HtrLNCBrCfcaP5Cs9b1CparFZrroSfHKibfw=
Message-ID: <e9e943910712040406g17ae4293u72ddb63b55549e63@mail.gmail.com>
Date: Tue, 4 Dec 2007 12:06:23 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: [patch] rd: support XIP
Cc: "Christian Borntraeger" <borntraeger@de.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, rob@landley.net,
       "Jens Axboe" <axboe@kernel.dk>
In-Reply-To: <20071204112100.GA20420@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071204042628.GA26636@wotan.suse.de>
	 <200712041054.51599.borntraeger@de.ibm.com>
	 <20071204101009.GB9618@wotan.suse.de>
	 <20071204112100.GA20420@wotan.suse.de>
X-Google-Sender-Auth: 76b4e370b0121e3f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2007, Nick Piggin <npiggin@suse.de> wrote:
> +       gfp_flags = GFP_NOIO | __GFP_ZERO;
> +#ifndef CONFIG_BLK_DEV_XIP
> +       gfp_flags |= __GFP_HIGHMEM;
> +#endif
>         page = alloc_page(GFP_NOIO | __GFP_HIGHMEM | __GFP_ZERO);

I think that should be alloc_page(gfp_flags), no?

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
