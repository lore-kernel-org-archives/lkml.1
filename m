Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbXBSNDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbXBSNDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 08:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932210AbXBSNDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 08:03:16 -0500
Received: from qb-out-0506.google.com ([72.14.204.233]:13629 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203AbXBSNDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 08:03:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=If7h6Z4Oqfcku0b/uFQBefwnQgHqiUAkQVPTfTIIenPU1iDwaB/Uf9VAV9t0DxRXNYt3cyrwxvVTwfOyfP7EcXKiREzhY1mzdSzZtsmdBxCmuOpacYOfQ7K6haUNof5G4KlCHP5T1/VWfBNYB8bSDjGv4Yjb/l0QRrs50GAP8E4=
Message-ID: <38b2ab8a0702190503n32caeab3j2c2139c71cb5a9c5@mail.gmail.com>
Date: Mon, 19 Feb 2007 14:03:13 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: memparse(), simple_strtoul() prototypes...
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45D8EFB8.4050805@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0702180804l26d99a01y558bce2ee964d973@mail.gmail.com>
	 <45D8EFB8.4050805@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 2/19/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Francis Moreau wrote:
> > Hi,
> >
> > I must miss something...
> >
> > Looking at these prototypes
> >
> > unsigned long simple_strtoul(const char *cp, char **endp,unsigned int base)
> > unsigned long long memparse (char *ptr, char **retptr)
> >
> > I'm really wondering why not all parameters are not all 'const'. None
> > of these functions modify any pointer containts. And simple_strtoul()
> > ends up doing sometghing like:
> >
> > if (endp)
> >         *endp = (char *)cp;
> >
> > Could anyone shed some light ?
>
> The C standard behaves like that, too, mostly because C doesn't have a
> way to say "X is const iff Y is const" (unlike C++, btw.)
>

hm, I don't get your point. I understand why we cast 'cp' into a (char
*) but that's not my point. My point is why aren't all function
parameters are not const ?

-- 
Francis
