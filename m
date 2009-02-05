Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbZBEWao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbZBEWao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbZBEWaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:30:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530AbZBEWaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:30:35 -0500
Date: Thu, 5 Feb 2009 14:29:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, phdm@macqel.be, hancockrwd@gmail.com,
       abelay@mit.edu, lenb@kernel.org, stable@kernel.org
Subject: Re: [PATCH] floppy: request only the ports we actually use
Message-Id: <20090205142948.1a48d983.akpm@linux-foundation.org>
In-Reply-To: <200902051055.34149.bjorn.helgaas@hp.com>
References: <20090205174859.18396.68512.stgit@bob.kio>
	<200902051055.34149.bjorn.helgaas@hp.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009 10:55:33 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> On Thursday 05 February 2009 10:48:59 am Bjorn Helgaas wrote:
> > The floppy driver requests an I/O port it doesn't need, and
> > sometimes this causes a conflict with a motherboard device
> > reported by PNPBIOS.
> > 
> > This patch makes the floppy driver request only the ports it
> > actually uses.
> > ...
> > Philippe reported that this conflict broke the floppy driver between
> > 2.6.11 and 2.6.22.  ...
> 
> While this is old and BIOS-specific, it is a regression, so we might
> consider it for 2.6.29.
> 

And earlier, surely?

I tagged it

Cc: <stable@kernel.org> [2.6.25.x, 2.6.26.x, 2.6.27.x, 2.6.28.x]

(I'm not sure if 2.6.25.x is still being maintained by Greg & Chris,
but other parties are maintaining 2.6.25-based kernels, and such
tagging might help them).

