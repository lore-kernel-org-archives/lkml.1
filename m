Return-Path: <linux-kernel-owner+w=401wt.eu-S934189AbYEGWpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934189AbYEGWpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756931AbYEGWp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:45:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:62066 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470AbYEGWpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UIThVpxdudHmSlVD7nIINHgt1eN1VaX5bIsCUtTy8uUlyxtnbmIDkHauh45TDXCb6CzzQdA1r1ZGIc+3C2yRox9txFOuY+eTM80fkD+YOnHOQinqOGkxF85fysjtPPBXJbt8xSxn1ykokvY0bfifm0B1RohKyN4MjZUcrsek83o=
Message-ID: <86802c440805071545v75c808a5qcc4a3388c8a0de4d@mail.gmail.com>
Date: Wed, 7 May 2008 15:45:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
Cc: "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080507223918.GK18516@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48210A71.1060409@keyaccess.nl>
	 <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>
	 <20080507124650.GD29935@cs181133002.pp.htv.fi>
	 <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>
	 <20080507212343.GB14951@cs181133002.pp.htv.fi>
	 <alpine.LFD.1.10.0805072341210.3318@apollo.tec.linutronix.de>
	 <20080507221435.GH18516@elf.ucw.cz>
	 <86802c440805071523u2d858727l2fc6d9edbd30cad8@mail.gmail.com>
	 <20080507223918.GK18516@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 3:39 PM, Pavel Machek <pavel@suse.cz> wrote:
> On Wed 2008-05-07 15:23:46, Yinghai Lu wrote:
>  > >  2) HPA said it was bad idea
>  >
>  > hpa said white list is not a good idea.
>
>  And guess what your patch is doing?
>
>
>  +       switch (c->x86_vendor) {
>  +       case X86_VENDOR_AMD:
>  +               if (c->x86 >= 0xf && c->x86 <= 0x11)
>  +                       set_cpu_cap(c, X86_FEATURE_PAT);
>  +               break;
>  +       case X86_VENDOR_INTEL:
>  +               if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >=
>  15))
>  +                       set_cpu_cap(c, X86_FEATURE_PAT);
>  +               break;
>  +       }
>
>  Seems like a whitelist to me. Will break with future CPUs.

again, i only increased the whitelist a little bit to support AMD
opteron Rev E, Rev F and Fam10h that I could access.

the code handle future cpus should reach the kernel list before SW
developer could get system....

YH
