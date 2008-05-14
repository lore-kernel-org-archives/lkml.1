Return-Path: <linux-kernel-owner+w=401wt.eu-S1759504AbYENCu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504AbYENCu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 22:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbYENCur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 22:50:47 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:16254 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853AbYENCue convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 22:50:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=j3t5VeI4od/Gx2bXkJ1kCsZRR/87h0aubWue6TcH9R8lnoKsI8/8nK4JEHLohjUo18i8nUEOQ2nmHO8i3Mw3RNqcowxmTipP6XY69RpQa3TJ5jzeWDHEwgI640dGZrFE2QdaiWqM9w5O6BBmtxpaIaWaCG8lUF8BPc8ZxmaOETQ=
Message-ID: <386072610805131950l196c6bbera7242bf517a2b838@mail.gmail.com>
Date: Wed, 14 May 2008 10:50:31 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@logfs.org>
Subject: Re: [PATCH 1/1] [MTD/MAPS] Blackfin Async Flash Maps: Handle the case where flash memory and ethernet mac/phy are mapped onto the same async bank
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, linux-mtd@lists.infradead.org,
       dwmw2@infradead.org, will.newton@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080513191616.GC18026@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1210653525-19437-1-git-send-email-cooloney@kernel.org>
	 <20080513080727.GA15795@logfs.org>
	 <8bd0f97a0805130542x46f5e7fejf1347f1c71f567fb@mail.gmail.com>
	 <20080513150143.GA18026@logfs.org>
	 <8bd0f97a0805130815q2ffa1d34ue87f5eb1422b6f42@mail.gmail.com>
	 <20080513153441.GB18026@logfs.org>
	 <8bd0f97a0805131042x2a74115dqc3831a604583bbd5@mail.gmail.com>
	 <20080513191616.GC18026@logfs.org>
X-Google-Sender-Auth: be3e4c1c79a8f53a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 3:16 AM, Jörn Engel <joern@logfs.org> wrote:
>
> On Tue, 13 May 2008 13:42:04 -0400, Mike Frysinger wrote:
>  > On Tue, May 13, 2008 at 11:34 AM, Jörn Engel <joern@logfs.org> wrote:
>  > > On Tue, 13 May 2008 12:38:45 +0800, Bryan Wu wrote:
>  > > > +#define pr_devinit(fmt, args...) ({ static const __devinitdata char __fmt[] = fmt; printk(__fmt, ## args); })
>  > >
>  > >  That bit is obvious.  But why do you use pr_devinit() instead of
>  > >  printk()?  What does it gain you?
>  >
>  > why do we have __init and __devinit in the first place ?
>
>  Ah.  Now I finally understand what this code does.
>
>  Might be worth moving it to include/linux/kernel.h, along with
>  pr_init().  And watch an avalanche of janitor patches use these new
>  toys. :)
>

Yes, I agree. Mike, could you consider providing a patch to add
pr_devinit to common code?
IMO, your weapon can be shared by others.

Thanks
-Bryan
