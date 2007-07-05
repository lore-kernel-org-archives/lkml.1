Return-Path: <linux-kernel-owner+w=401wt.eu-S1761080AbXGESaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761080AbXGESaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 14:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759484AbXGES3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 14:29:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41650 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756948AbXGES3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 14:29:51 -0400
Date: Thu, 5 Jul 2007 11:28:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linas@austin.ibm.com (Linas Vepstas)
Cc: James.Bottomley@steeleye.com, matthew@wil.cx, willy@debian.org,
       linux-scsi@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH]: PCI Error Recovery: Symbios SCSI device driver
Message-Id: <20070705112838.2d8c959b.akpm@linux-foundation.org>
In-Reply-To: <20070702183917.GJ4501@austin.ibm.com>
References: <20070702183917.GJ4501@austin.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2007 13:39:17 -0500
linas@austin.ibm.com (Linas Vepstas) wrote:

> 
> Various PCI bus errors can be signaled by newer PCI controllers.  
> This patch adds the PCI error recovery callbacks to the Symbios 
> SCSI device driver.  The patch has been tested, and appears to 
> work well.
> 

yup, this is identical to -mm's
pci-error-recovery-symbios-scsi-base-support.patch

What is the status of
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/pci-error-recovery-symbios-scsi-first-failure.patch?

> 
> ----
> 
> Hi,
> 
> This patch has been bouncing around for a long time, and has made
> appearences in various -mm trees since 2.6.something-teen. However,
> it has never made it into mainline, and I'm starting to get concerned
> that it will miss 2.6.23 as well. 

Well you've sent it a couple of times, and I've sent it in five more times
over the past year.  Once we were told "awaiting maintainer ack".

This situation is fairly stupid.  How about we make you the maintainer?

