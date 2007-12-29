Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbXL2CgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbXL2CgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 21:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbXL2CgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 21:36:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:33624 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbXL2Cf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 21:35:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dWXlFCts2Z22zXKq3+wvJ/AgG3SXmUF+Y20RY7jrluo9f4lzKN2P3+551AK/pzzH8hrYdNYWeiHb2xNfwenyvG6juYTUoKFdiKMVOyDuA/WQ/mnu21okc5cIgJ6WFyf957ynQzw6ocdzCTD/t+Z4OxRvzzR3aqxjmDh3k+mRPGU=
Message-ID: <6101e8c40712281835m6205fe91p8ecf37a2eac9d432@mail.gmail.com>
Date: Sat, 29 Dec 2007 03:35:56 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [2.6.23(?)=<] X used greatest stack depth: N bytes left
Cc: linux-kernel@vger.kernel.org,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
In-Reply-To: <20071228171312.baa0776b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40712281311p446f64e1xb28f8fc273545041@mail.gmail.com>
	 <20071228153258.bef76bb2.randy.dunlap@oracle.com>
	 <6101e8c40712281658i2ac7a27du4b0964afd043280e@mail.gmail.com>
	 <20071228171312.baa0776b.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Sat, 29 Dec 2007 01:58:44 +0100 Oliver Pinter (Pintér Olivér) wrote:
>
> > On 12/29/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > On Fri, 28 Dec 2007 22:11:25 +0100 Oliver Pinter (Pintér Olivér) wrote:
> > >
> > > > in newer kernel I recently see this warnings:
> > > >
> > > > X used greatest stack depth: N bytes left
> > > >
> > > > X E { program name }
> > > > N E { x byte }
> > > >
> > > > ----------------8<--------------
> > > > ...
> > > > khelper used greatest stack depth: 7496 bytes left
> > > > khelper used greatest stack depth: 7184 bytes left
> > > > ...
> > > > khelper used greatest stack depth: 6328 bytes left
> > > > stty used greatest stack depth: 6180 bytes left
> > > > mount used greatest stack depth: 6156 bytes left
> > > > mknod used greatest stack depth: 5932 bytes left
> > > > ...
> > > > wpa_supplicant used greatest stack depth: 5740 bytes left
> > > > ...
> > > > dhclient3 used greatest stack depth: 5500 bytes left
> > > > ----------------8<--------------
> > > >
> > > > it is the "results" of the CONFIG_DEBUG_STACKOVERFLOW=y
> > > > CONFIG_DEBUG_STACK_USAGE=y options or it's other problem or feature?
> > >
> > > CONFIG_DEBUG_STACK_USAGE, in kernel/exit.c:
> > >
> > > ---
> >
> > sure, but to 2.6.22 or 2.6.23-rcX (with merged the cfs scheduler)
> > don't show this warnings, but the CONFIG_DEBUG_STACK_USAGE is enabled.
>
> Sorry, I couldn't tell that you were asking more than that.
>
> In 2.6.22, CONFIG_DEBUG_STACK_USAGE only causes output during
> sysrq-W (show blocked state).
>
> In 2.6.24-rc, CONFIG_DEBUG_STACK_USAGE also causes output during
> process exit, which is what you are seeing.
>
> Does that help?

yes, thanks, then it's the answer

sorry, for my bad  composition/spelling

-- 
Thanks,
Oliver
