Return-Path: <linux-kernel-owner+w=401wt.eu-S1759651AbYLKTvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651AbYLKTvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761012AbYLKTsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:48:03 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51036 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760903AbYLKTr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:47:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=l1bUowHlaW+G87iIVmUZoLneF6N1TKcYnaZ7hgI7+bYJdnca3EmDYkMdisiLZTQ5Mm
         toCO7k/47etEVI/2mhJPMhSfSkviVCog8zoOcrGWRdq+RG6oBCDiTwurKB0lvburns3P
         cAULxKw2+z3hwNEl0cDhAtvWG5hgmz5vUB/i8=
Message-ID: <84144f020812111147h77587bd2t9dbe03f132cb1153@mail.gmail.com>
Date: Thu, 11 Dec 2008 21:47:57 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Dave Hansen" <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 07/15] kmemleak: Add memleak_alloc callback from alloc_large_system_hash
Cc: "Catalin Marinas" <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1229017506.17206.7.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182732.30323.39834.stgit@pc1117.cambridge.arm.com>
	 <1228935860.9737.98.camel@nimitz>
	 <1228989052.332.12.camel@pc1117.cambridge.arm.com>
	 <1229016618.17206.2.camel@nimitz>
	 <1229017098.332.45.camel@pc1117.cambridge.arm.com>
	 <1229017506.17206.7.camel@nimitz>
X-Google-Sender-Auth: 7a4130d93044057a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-11 at 17:38 +0000, Catalin Marinas wrote:
>> Do you mean a comment? I can do this.

On Thu, Dec 11, 2008 at 7:45 PM, Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> Yeah, something like
>
> /*
>  * kmemleak doesn't actually allocate memory when called this early
>  * so the GFP_ATOMIC here is actually meaningless, but consistent
>  * with the rest of this function.
>  */
>
> Maybe that's too verbose. :)

I'd suggest just doing a separate kmemleak_early_alloc() hook without
the gfp flag.
