Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab0AOHl6 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 02:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962Ab0AOHlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 02:41:55 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:55369 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab0AOHlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 02:41:50 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: ss@aao.gov.au
Subject: Re: [RFC] Yet another dt3155 driver for drivers/staging
Date: Thu, 14 Jan 2010 21:23:57 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.33-rc4; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <201001122242.22774.mitov@issp.bas.bg> <201001130816.43855.mitov@issp.bas.bg> <20100114010335.GB20569@aao.gov.au>
In-Reply-To: <20100114010335.GB20569@aao.gov.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001142123.57736.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scot & Greg,

> 
> I'd be interested in Marin's opinion as he appears to have used both
> drivers extensively.

I have successfully used SourceForge(SF) driver since 2003 on 2.4.xx
kernels till the time of 2.6.17 kernel when I switched to 2.6.17 as described in

http://lfb.issp.bas.bg/~mitov/linux/dt3155pci/00README

At this time I needed 1 fps, so the SF driver was OK for me.

> 
> I'd like a userspace program to actually try out Marin's driver

I have one using KDE 3.5 libraries. If you use KDE 3.5 I could send it to you.

> , but
> I can still make some general comments:
> 
> Things I like about Marin's driver:
> - It is only ~1/3rd the size. (by counting new lines)
> - The code is much neater.
> - It can acquire frames at 25 fps (real-time), according to Marin.

Since today it could do 30 fps as well :-). Updated.

> - At least 1 person with intimate knowledge of the code seems keen to
>   maintain it.
> 
> Things I like about the sourceforge (SF) driver:
> - It works in CCIR mode (768x576) or 640x480 mode.

Since today - here also.

> - It is well tested.
> - It works with most kernel versions. ie. 2.2, 2.4, & 2.6. (mostly)

Production tested/used (every day use) on 2.6.27.43-i686.
Compile tested on 2.6.33.-rc4-x86_64 :-)

> - It works with multiple boards.

Here in principal - also, but not tested.

> - The code is moderately well commented.
> - It includes simple (user space) example programs.
> 
> 
> Clearly each driver has strengths over the other.
> 
> It would probably be easier to upgrade Marin's driver to match the
> strengths of the SF driver than the other way around. The only
> difficulty might be in making Marin's driver work with older kernel
> versions. IMO, that's probably an acceptable sacrifice to make. (For
> users of legacy systems, we could point them to the (unmaintained)
> driver on SF.)
> 
> Marin, if you are considering upgrading your driver, I propose
> we send an email to the DT3155 SF mailing list & ask for help
> testing. 

OK. I agree. Which kind of upgrade you mean?

If CCIR/RS-170 - it is already done (but not tested on RS-170, 
I have no such camera).

I would ask your help for contacting  "the DT3155 SF mailing list & ask for help"

> (I already know of 1 other person who is happy to help
> test.) I recommend making userspace programs (like examples/acquire
> & examples/Xview in the SF driver) available first. Ideally, these
> example programs & user space libraries would become the major
> component of the evolved DT3155 SF project.

Here I could propose a KDE program, but it needs KDE, I am not familiar
with GNOME programing.

Marin Mitov
