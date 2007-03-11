Return-Path: <linux-kernel-owner+w=401wt.eu-S1751576AbXCKUBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbXCKUBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 16:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbXCKUBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 16:01:53 -0400
Received: from mail0.lsil.com ([147.145.40.20]:55147 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbXCKUBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 16:01:52 -0400
Date: Sun, 11 Mar 2007 13:55:54 -0600
From: Eric Moore <eric.moore@lsi.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] MPT FUSION:  Delete unused header files.
Message-ID: <20070311195553.GA12056@lsil.com>
References: <Pine.LNX.4.64.0703101656150.28403@CPE00045a9c397f-CM001225dbafb6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703101656150.28403@CPE00045a9c397f-CM001225dbafb6>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 04:57:35PM -0500, Robert P. J. Day wrote:
> 
>   Delete apparently unused header files.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
>  drivers/message/fusion/lsi/mpi_inb.h    |  221 ----------------------
>  drivers/message/fusion/lsi/mpi_log_fc.h |   89 --------
>  2 files changed, 310 deletions(-)
> 

NACK.

Thanks, but no thanks.  Don't remove these header files.  These are the mpi
header files that define the interface between firmware and drivers.  This
set of headers are bundled with each flavor OS, and we are constantly
providing update files when changes occur.

With respect to mpi_log_fc.h - this defines the loginfo for fibre channel
protocal.  This is a easy lookup to for LSI Logic customers to better
understand the kind of errors returned from firmware, and help reduce number
of support generated request, as the end user can merely lookup the unqiue
id in the header file.    mpi_inb.h, is header for fibre channel protocal
definii
ng the inband-management interface, and maybe implemented some day.

Eric Moore
LSI Logic



