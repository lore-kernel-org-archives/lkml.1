Return-Path: <linux-kernel-owner+w=401wt.eu-S1750814AbZLEFrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750814AbZLEFrK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 00:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbZLEFrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 00:47:10 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:42618 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZLEFrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 00:47:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YGOO39p/ncNVIbhROi3Xo3j5uWddI4WRIuw/FSixdaiGYAjgcxYGsMvJnkXWzuQOwW
         xEY+CFztWSigLfS10Y0H3KLutk/N05iMYcKsyjYi9YG2R5UVkggtHPHtejJh3B16cFZA
         yKDU8IpS1e5s3FvDqz2d0FDgMh7aedHg2Rbys=
MIME-Version: 1.0
In-Reply-To: <20091205052802.GD10777@ldl.fc.hp.com>
References: <b9df5fa10912040835k3e23702o8700d2d8ad2349a4@mail.gmail.com>
	 <20091204202709.GA32347@ldl.fc.hp.com>
	 <b9df5fa10912041753n27e60020x2dd41eb50f4608ff@mail.gmail.com>
	 <20091205043635.GA10777@ldl.fc.hp.com>
	 <b9df5fa10912042118p733416ffwe21b79b1f8246f2f@mail.gmail.com>
	 <20091205052802.GD10777@ldl.fc.hp.com>
Date: Sat, 5 Dec 2009 11:47:15 +0600
Message-ID: <b9df5fa10912042147s2ef7e4c9g538a9301c111964c@mail.gmail.com>
Subject: Re: [PATCH] pci: Make pci_dev struct point to NULL.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Alex Chiang <achiang@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/5/09, Alex Chiang <achiang@hp.com> wrote:
> * Rakib Mullick <rakib.mullick@gmail.com>:
>  >
>
> > Since *pdev might be uninitialized. But if we are sure that it
>  > is not uninitialized then it is okay.
>  >
>  > And yes - althrough we weren't warned by the compiler.
>
>  At no point that I can tell do we ever access an uninitialized
>  'dev'.
>
>  Please explain to me one more time what you think you are fixing.
>
 Ahh......... I miss the point that we haven't __access__ the uninitialized
pointer. I was messing up with it __remains__ uninitialized ( it was a
clear stupidity from me :-(       ).

Thanks,  Alex for your help.

Rakib,

>  Thanks,
>
> /ac
>
