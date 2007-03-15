Return-Path: <linux-kernel-owner+w=401wt.eu-S1030242AbXCOM5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030242AbXCOM5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 08:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030224AbXCOM5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 08:57:23 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:33505 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030242AbXCOM5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 08:57:22 -0400
X-Originating-Ip: 74.108.131.3
Date: Thu, 15 Mar 2007 08:52:15 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Remove "decl_subsys_name" macro and single usage of it.
In-Reply-To: <3ae72650703150322h10882044nbcfdddd4187d31ce@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703150630270.23698@localhost.localdomain>
References: <Pine.LNX.4.64.0703011205510.20928@CPE00045a9c397f-CM001225dbafb6>
 <3ae72650703150322h10882044nbcfdddd4187d31ce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-14.839, required 5, ALL_TRUSTED -1.80, BAYES_00 -15.00,
	DATE_IN_FUTURE_03_06 1.96)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, Kay Sievers wrote:

> On 3/1/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> >
> >   Remove the macro "decl_subsys_name" which can be used to declare a
> > sysfs subsystem, along with the single invocation of it in the source
> > tree, since there appears to be little value in creating a subsystem
> > whose subsystem name differs from its structure name.  Everyone else
> > just uses "decl_subsys".
>
> Sometimes you want shorter variable names as the created objects in
> sysfs, because the 80 columns limit of the kernel source makes long
> variable names pretty inconvenient.
> And all these decl_* macros, obviously can't create any names that
> contain '-', which is pretty annoying. There is also a user in the
> experimental patches in Greg's tree. Please leave it there for now.

no problem but that patch *was* based on a suggestion by greg in the
first place.  i'm guessing he just forgot. :-)

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
