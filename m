Return-Path: <linux-kernel-owner+w=401wt.eu-S1759114AbXEVWvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114AbXEVWvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756655AbXEVWvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:51:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52110 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755362AbXEVWvg (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:51:36 -0400
Date: Tue, 22 May 2007 15:49:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: richard.griffiths@windriver.com
Cc: Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org,
       Carsten Otte <cotte@de.ibm.com>
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-Id: <20070522154905.1d7e8a2e.akpm@linux-foundation.org>
In-Reply-To: <1179871779.24163.11.camel@localhost.localdomain>
References: <1179871779.24163.11.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 15:09:39 -0700
Richard Griffiths <res07ml0@verizon.net> wrote:

> Venerable cramfs fs Linear XIP patch originally from MontaVista, used in
> the embedded Linux community for years, updated for 2.6.21. Tested on
> several systems with NOR Flash. PXA270, TI OMAP2430, ARM Versatile and
> Freescale iMX31ADS.

It's good to see some of these secret embedded patches heading in
the mainline direction.

But we'd expected and hoped that flash-based XIP would be able to use
the existing xip infrastructure, in mm/filemap_xip.c.  Not possible?

The de-constification of cramfs_ops and cramfs_dir_inode_operations
was, I assume, a mistake?
