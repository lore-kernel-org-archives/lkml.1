Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbXITOh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbXITOh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 10:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbXITOhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 10:37:15 -0400
Received: from twin.jikos.cz ([213.151.79.26]:60804 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbXITOhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 10:37:14 -0400
Date: Thu, 20 Sep 2007 16:37:09 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ACPI video mode patch review
In-Reply-To: <b6a2187b0709200722q2755111brb8b7c3bdc71e2129@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0709201635000.24429@twin.jikos.cz>
References: <46E9AD88.7070400@zytor.com>  <Pine.LNX.4.64.0709201617440.24429@twin.jikos.cz>
 <b6a2187b0709200722q2755111brb8b7c3bdc71e2129@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007, Jeff Chua wrote:

> > With your patch applied, I get no video at all after resume (I tried all
> > three possible combinations of acpi_sleep parameter).
> Can you please try again with 2.6.23-rc7. The patch is already
> included in -rc7 and it works for me on Lenono X60s.

With current -git, I still get the same behavior as with 
previous 2.6.23-rcX kernels - i.e. after resume (with 
acpi_sleep=s3_bios,s3_mode), I get corrupted image resembling the BIOS 
POST graphics.

Previous kernels (I am currently pretty sure that 
15028aad00ddf241581fbe74a02ec89cbb28d35d was OK, but I haven't done the 
bisection yet) resumed perfectly with acpi_sleep=s3_bios,s3_mode on this 
machine.

Please note that this is very different HW than you have - it is sort-of a 
desktop machine, not a notebook at all.

-- 
Jiri Kosina
