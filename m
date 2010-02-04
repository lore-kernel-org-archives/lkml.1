Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167Ab0BDFNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 00:13:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750743Ab0BDFNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 00:13:39 -0500
Date: Wed, 3 Feb 2010 21:13:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Lord <kernel@teksavvy.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 02/10] drivers/ata: Fix continuation line formats
Message-Id: <20100203211331.81d9bb69.akpm@linux-foundation.org>
In-Reply-To: <4B6A5443.6090804@teksavvy.com>
References: <cover.1265095093.git.joe@perches.com>
	<12d39ac4f14bfe82a02b4ee246d183b48988fe12.1265095094.git.joe@perches.com>
	<4B69B0A0.2040701@teksavvy.com>
	<1265224535.24887.16.camel@Joe-Laptop.home>
	<4B6A5443.6090804@teksavvy.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Feb 2010 23:59:47 -0500 Mark Lord <kernel@teksavvy.com> wrote:

> Joe Perches wrote:
> > On Wed, 2010-02-03 at 12:21 -0500, Mark Lord wrote:
> >> Joe Perches wrote:
> >>> String constants that are continued on subsequent lines with \
> >>> are not good.
> > []
> >>> -		dev_warn(ap->dev, "Failed to compute ATA timing %d, \
> >>> -				set PIO_0 timing\n", ret);
> >>> +		dev_warn(ap->dev, "Failed to compute ATA timing %d, set PIO_0 timing\n",
> >>> +			 ret);
> >> NAK.  Just stick the ret); part onto the same line and be done with it.
> > 
> > :resend that I mistakenly sent only to Mark, with a couple more comments
> > 
> > I disagree.
> > 
> > Look at the long line wrapping style of the rest of the file
> > and most of the kernel source.  No additional arguments to
> > functions are generally used after column 80.
> > 
> > If it's ever agreed that all lines > 80 cols are OK or
> > new args after column 80 are OK, then sure.  Until then,
> > if you want it, you should do it.
> ..
> 
> You are the code nanny trying to get this patch in.  Not me.
> 

It's a runtime bug.  Are "code nannies" supposed to "try" to fix
runtime bugs in libata while others just sit there and insult them?
