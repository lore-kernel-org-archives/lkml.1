Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbXJYQQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbXJYQQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXJYQQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:16:41 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:52220 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbXJYQQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:16:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e2i1e2PUO0v7c4D3/SpSJu6oL+RhGwVylbZvc4xVd8QQHPgfQztZ8hd08ztW4OYZQRt3RqxmZvKonx5XXj5Rvc8k920KI3FDmCeeNn0c2Z2g3vMTcdxN/Yc5DEx3Xn+YqdfRnA2zBp2HzOVPxDpr09mT7bSG3swnhrTvF1Izv+I=
Message-ID: <8bd0f97a0710250916v5d3f0166qbfacf4abb0fc3d45@mail.gmail.com>
Date: Thu, 25 Oct 2007 12:16:40 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] blackfin: "extern inline" -> "static inline"
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Jie Zhang" <jzhang.linux@gmail.com>,
       bryan.wu@analog.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071025150545.GK30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024162643.GP30533@stusta.de>
	 <40401db90710241947i15e40e78v292e52f5229d9d35@mail.gmail.com>
	 <8bd0f97a0710242000h7b6c97e7ia3f461c69b7d5de5@mail.gmail.com>
	 <47200826.1060801@zytor.com> <20071025150545.GK30533@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/07, Adrian Bunk <bunk@kernel.org> wrote:
> On Wed, Oct 24, 2007 at 08:06:14PM -0700, H. Peter Anvin wrote:
> > Mike Frysinger wrote:
> >> we'll have to either use the gcc attributes to force old inline
> >> behavior or use the gcc flag to force it
> >
> > We should probably have an extern_inline define then, assuming this is a
> > function that does exist in a linkable version already -- otherwise "static
> > inline" is correct.
>
> Since we #define inline to be __attribute__((always_inline))
> "extern inline" with the old semantics would only behave differently
> if someone took the address of one of these string functions.

that isnt what we intended ;)

> Does this happen anywhere in the blackfin port?

gcc is also free to ignore the optimized inline in favor of an
external reference
-mike
