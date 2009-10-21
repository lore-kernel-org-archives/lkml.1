Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbZJULY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbZJULY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 07:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbZJULY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 07:24:27 -0400
Received: from nox.protox.org ([88.191.38.29]:36699 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbZJULY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 07:24:27 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Oct 2009 07:24:27 EDT
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 
 0000000000000004
From: Jerome Glisse <glisse@freedesktop.org>
To: Jike Song <albcamus@gmail.com>
Cc: Ben Nizette <bn@niasdigital.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <df9815e70910202325r1004ef7exe7bed24e1fc14a17@mail.gmail.com>
References: <df9815e70910202204q5a0593e1gd14b9d36c368861e@mail.gmail.com>
	 <1256105727.9801.105.camel@ben-desktop>
	 <df9815e70910202324o1af88a3cg82093fc5e0bf7929@mail.gmail.com>
	 <df9815e70910202325r1004ef7exe7bed24e1fc14a17@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Oct 2009 13:11:35 +0200
Message-Id: <1256123495.1934.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-21 at 14:25 +0800, Jike Song wrote:
> On Wed, Oct 21, 2009 at 2:15 PM, Ben Nizette <bn@niasdigital.com> wrote:
> > On Wed, 2009-10-21 at 13:04 +0800, Jike Song wrote:
> >
> >> Pid: 3427, comm: Xorg Tainted: G      D    2.6.32-rc5-00011-g2fdc246
> >
> > the "D" means this isn't the first oops/bug since boot; please post all
> > bugs and/or full dmesg.  Given all the invalid ioctl noise an Xorg
> > version might help too.
> >
> > Thx,
> >        --Ben.
> 
> Ben,
> 
> Thank you for telling me this. The whole dmesg output is attached.
> 
> --
> Thanks,
> Jike

I think you have activated radeon KMS and you have a too old userspace.
You need git version of libdrm,xserver,ddx,mesa to be able to use KMS.
See: http://dri.freedesktop.org/wiki/Radeon

That being said it should not oops or bug, i will recheck this code.

Cheers,
Jerome

