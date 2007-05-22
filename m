Return-Path: <linux-kernel-owner+w=401wt.eu-S1759490AbXEVW7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490AbXEVW7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbXEVW7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:59:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:33529 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362AbXEVW7P (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:59:15 -0400
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
From: "Richard Griffiths (wrs)" <richard.griffiths@windriver.com>
Reply-To: richard.griffiths@windriver.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-kernel@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>
In-Reply-To: <20070522154905.1d7e8a2e.akpm@linux-foundation.org>
References: <1179871779.24163.11.camel@localhost.localdomain>
	 <20070522154905.1d7e8a2e.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux Product Development
Date: Tue, 22 May 2007 15:58:29 -0700
Message-Id: <1179874709.17209.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 22 May 2007 22:58:30.0307 (UTC) FILETIME=[B71E0730:01C79CC4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-22 at 15:49 -0700, Andrew Morton wrote:
> On Tue, 22 May 2007 15:09:39 -0700
> Richard Griffiths <res07ml0@verizon.net> wrote:
> 
> > Venerable cramfs fs Linear XIP patch originally from MontaVista, used in
> > the embedded Linux community for years, updated for 2.6.21. Tested on
> > several systems with NOR Flash. PXA270, TI OMAP2430, ARM Versatile and
> > Freescale iMX31ADS.
> 
> It's good to see some of these secret embedded patches heading in
> the mainline direction.
> 
> But we'd expected and hoped that flash-based XIP would be able to use
> the existing xip infrastructure, in mm/filemap_xip.c.  Not possible?
I don't know I'll look into it and see if it is possible.
> 
> The de-constification of cramfs_ops and cramfs_dir_inode_operations
> was, I assume, a mistake?
oops. Yes, Thanks Andrew.

Richard

