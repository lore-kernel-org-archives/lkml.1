Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbXGTMKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbXGTMKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 08:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbXGTMKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 08:10:09 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:6799 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbXGTMKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 08:10:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TXvfI0qJXNiDeT6PVJAkjP0B0D1pqTAuiaYUB2mh8dESt2Ep0ZZdfArudFLsV5qi7h2dSxNw4TQM7lZvzRipNNrmidmyNz9rANme8SckIfTiZirgx/JcJJziZXZASx/UlLvYehi/N1pnkBj0kd+e0A3e6SQ0IzMU3cxoKnO1Dco=
Message-ID: <a781481a0707200510n30916e33uec3d13ac3336813b@mail.gmail.com>
Date: Fri, 20 Jul 2007 17:40:05 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: werner <werner@copaya.yi.org>
Subject: Re: Kernel Error / Crash
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <a781481a0707192053t4991ff51l899e068c3fc6aaa2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184901372.4269@werner>
	 <a781481a0707192053t4991ff51l899e068c3fc6aaa2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> Hi Werner,
>
> On 7/20/07, werner <werner@copaya.yi.org> wrote:
> > To: linux-kernel@vger.kernel.org
> >
> >
> > copied from the screen:
> >
> > ...
> > proc on /proc type proc (rw)
> > sysfs on /sys type sysfs (rw)
> > Starting udevd: /sbin/udevd -- daemon
> > ------------[cut here]-------------------
> > Kernel BUG at mm/slub.c:2401!
>
> That's ksize(invalid_address) -- when the address belongs to an
> !PageSlab page.

Oh, ok so this is fixed in 9550b105b8646f916862aee3ab7b25020ca14159
in mainline -git for some time now.

[ turns out the bug was in ksize() itself, so there wasn't need for
a stack trace after all :-p ]
