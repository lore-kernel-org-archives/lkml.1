Return-Path: <linux-kernel-owner+w=401wt.eu-S1752427AbYFEQ64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbYFEQ64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbYFEQ6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:58:47 -0400
Received: from mailout.softservecom.com ([195.160.232.25]:51019 "EHLO
	mailout.softservecom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbYFEQ6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:58:46 -0400
X-Greylist: delayed 1557 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2008 12:58:46 EDT
Subject: Re: [PATCH resend] Adding dummy release functions to avoid
	warnings.
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Reply-To: vitalivanov@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
       devzero@web.de, jsun@junsun.net, dwmw2@infradead.org,
       protasnb@gmail.com, linux-fbdev-devel@lists.sourceforge.net
In-Reply-To: <20080605090725.96da4b75.akpm@linux-foundation.org>
References: <1208306056.15140.13.camel@pcvitaliy>
	 <35fbaa3e0806050239y5987fc33rd349be8d07bc1262@mail.gmail.com>
	 <20080605090725.96da4b75.akpm@linux-foundation.org>
Content-Type: text/plain
Message-Id: <1212683557.21310.32.camel@dell1.softservecom.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.5 (1.4.5-21.el3) 
Date: Thu, 05 Jun 2008 19:32:37 +0300
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Thu, 2008-06-05 at 19:07, Andrew Morton wrote:
> On Thu, 5 Jun 2008 12:39:46 +0300 "Vitaliy Ivanov" <vitalivanov@gmail.com> wrote:
> > Trivial fix for #9690.
> > Added simple release functions that doing nothing.
> > Not sure whether we can leave it as is or to rework using
> > platform_device helpers like platform_device_alloc.
> 
> Please see Documentation/kobject.txt - search for the text
> "mocked mercilessly" :)
> 
> > This approach is used in many drivers.
> > --
> > 
> >  drivers/mtd/maps/physmap.c |    6 ++++++
> 
> Let's mock David too!

Damn. I knew that everything is not so easy here;) Got it. Tnx.

But in such case there are _again_ many drivers that do implement such
fake functions. Again is because when I tried to port some usb driver
there were issues with locking that was not correct but many drivers
worked exactly this incorrect way.

Anyway, tnx for clarifying this.

V.

