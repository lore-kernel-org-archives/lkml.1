Return-Path: <linux-kernel-owner+w=401wt.eu-S2993114AbXDYWvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993114AbXDYWvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993117AbXDYWvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:51:54 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:12372 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993114AbXDYWvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:51:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z8DCk3VLIhJbzOiD++pZ9kOkpJ3kOeFkzyEkan+ZG97VTajS33e5WGFyoNit/KVT2LWkwEnzINXC912RpZcrZ78ZiMg06x2QPcSHft6hbimXZgL1EadDenT7FnEGwB5wGX2QuFeE495rLvPl+U87yLY8ShtfZtb1h61FwkdmVnQ=
Message-ID: <8355959a0704251551qff39452h5cbd58f87c2173b3@mail.gmail.com>
Date: Thu, 26 Apr 2007 04:21:52 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: "Michael Tokarev" <mjt@tls.msk.ru>
Subject: Re: menuconfig issue (checklist) in 2.6.20.7 & 2.6.21-rc7 ?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <462F6788.1040806@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8355959a0704250724g3614d293h2dd08833a6ef473b@mail.gmail.com>
	 <462F6788.1040806@msgid.tls.msk.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/07, Michael Tokarev <mjt@tls.msk.ru> wrote:
> > [sukhoi@Akula2 linux-2.6.20.7]$ sudo make menuconfig
>
> Don't compile kernel as root.
>
That was a mistake out of hurry, I never compile as root (sudo).

> >  HOSTCC  scripts/kconfig/lxdialog/checklist.o
> > In file included from scripts/kconfig/lxdialog/checklist.c:24:
> > scripts/kconfig/lxdialog/dialog.h:32:20: error: curses.h: No such file or directory
>
> And before doing make menuconfig, install ncurses package (both
> the library and development files).
>

Just got the time to look back to the problem. Silly me (not getting
the thought to cross-check), this kernel work is really blowing up my
nights & mind ;-) Thanks to all.

> /mjt
>
~Akula2
