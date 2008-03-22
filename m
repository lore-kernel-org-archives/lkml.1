Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYCVG1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYCVG1O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 02:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbYCVG1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 02:27:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273AbYCVG1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 02:27:01 -0400
Date: Fri, 21 Mar 2008 23:26:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.25-rc6: kernel BUG at fs/sysfs/file.c:89
Message-Id: <20080321232632.84a2af8a.akpm@linux-foundation.org>
In-Reply-To: <20080322062025.GA28146@kroah.com>
References: <alpine.DEB.1.00.0803212319130.17137@sheep.housecafe.de>
	<200803220226.35552.rjw@sisk.pl>
	<20080321222606.16407d74.akpm@linux-foundation.org>
	<20080322062025.GA28146@kroah.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008 23:20:25 -0700 Greg KH <greg@kroah.com> wrote:

> > - we're killing people's machines.  Can we switch it to a
> >   WARN_ON()+fix-up-the-mess?
> 
> The patch above does just that, it's queued up for .26, but I have no
> objection to add it now if you want.

It'd be best to do so, I think.

Upsides: we get more debug info and we might save people's machines

Downsides: ???

