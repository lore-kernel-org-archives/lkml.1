Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbXCPHls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbXCPHls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 03:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932240AbXCPHls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 03:41:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:25048 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbXCPHlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 03:41:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QinqzbIz/RYCnqvPyjg+m1RTMMFsj7zrEazvFxkmIzK1rRTDGCPqphHynf4oEE84c8JjPwHeJANsTrBLp8MMM+FoBwzyIQWVc/Vl7kPDZPtp8VanNNXFdKjG1YQTzrK2HcNTDDMM1y0fGX88rfaR+WXSCq3JhuEldubDSBqqMGA=
Message-ID: <639c60080703160041y1ccdd29cn3aece7ec8ccf6b39@mail.gmail.com>
Date: Fri, 16 Mar 2007 08:41:45 +0100
From: Nilshar <nilshar@gmail.com>
To: "Leroy van Logchem" <leroy.vanlogchem@wldelft.nl>
Subject: Re: [Bug 8040] Hang before INIT when CONFIG_HIGHMEM4G=y [Fix CONFIG_COMPAT_VDSO] <- Bad?
Cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Roland McGrath" <roland@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       rdunlap@xenotime.net
In-Reply-To: <45F95435.8000805@wldelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703141013.l2EADP6c027144@fire-2.osdl.org>
	 <loom.20070314T184515-284@post.gmane.org>
	 <20070314170113.9c3c75c7.akpm@linux-foundation.org>
	 <200703150113.53212.ak@suse.de> <45F95435.8000805@wldelft.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Correcting my previous message, and confirming Leroy's one :

> linux-2.6.20.tar.gz   : bad
> linux-2.6.20.1.tar.gz: bad
> linux-2.6.20.2.tar.gz: good
> linux-2.6.20.3.tar.gz: good

With :
> COMPAT_VDSO=y
> CONFIG_HIGHMEM64G=y

So problem have been solved with 2.6.20.2

Nilshar.



2007/3/15, Leroy van Logchem <leroy.vanlogchem@wldelft.nl>:
> > Can you please double check this by trying with/without again -- sometimes bisects go bad.
> As requested I started to redo the test but now without git using
> kernel.org tars.
> The results now are, still using the same .config:
> linux-2.6.20.tar.gz   : bad
> linux-2.6.20.1.tar.gz: bad (boot log equal)
> linux-2.6.20.2.tar.gz: good
> linux-2.6.20.3.tar.gz: good
> (triple checked)
>
> Really strange. Nilshar, please try these kernels too with:
> COMPAT_VDSO=y
> CONFIG_HIGHMEM64G=y
>
>
>
