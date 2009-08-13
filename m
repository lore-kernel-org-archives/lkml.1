Return-Path: <linux-kernel-owner+w=401wt.eu-S1753032AbZHMIjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbZHMIjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbZHMIjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:39:24 -0400
Received: from smtp.nokia.com ([192.100.122.230]:17770 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbZHMIjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:39:23 -0400
Date: Thu, 13 Aug 2009 11:38:24 +0300
From: "Vignatti Tiago (Nokia-D/Helsinki)" <tiago.vignatti@nokia.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>
Subject: Re: linux-next: pci tree build warning
Message-ID: <20090813083824.GB24485@cachaca>
Reply-To: tiago.vignatti@nokia.com
References: <20090813124732.f29fd5c3.sfr@canb.auug.org.au> <1250134360.3587.77.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250134360.3587.77.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 13 Aug 2009 08:38:26.0759 (UTC) FILETIME=[6D41FD70:01CA1BF1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 05:32:40AM +0200, Benjamin Herrenschmidt wrote:
> On Thu, 2009-08-13 at 12:47 +1000, Stephen Rothwell wrote:
> > Hi Jesse,
> > 
> > Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> > 
> > drivers/gpu/vga/vgaarb.c: In function 'vga_arb_write':
> > drivers/gpu/vga/vgaarb.c:834: warning: cast from pointer to integer of different size
> > drivers/gpu/vga/vgaarb.c:870: warning: cast from pointer to integer of different size
> > drivers/gpu/vga/vgaarb.c:920: warning: cast from pointer to integer of different size
> > drivers/gpu/vga/vgaarb.c:963: warning: cast from pointer to integer of different size
> > drivers/gpu/vga/vgaarb.c:1017: warning: cast from pointer to integer of different size
> > 
> > Introduced by commit a49c9c1b728fa8f50816d96a0f135e15a359e448 ("PCI/GPU:
> > implement VGA arbitration on Linux").
> 
> Right, somebody weirdly decided to cast pointers to int just to printk
> them with %X :-) I hope it wasn't me ... 

Ahhh oops.. looks like someone really newbie trying to play developing kernel
code :p
 
            Tiago
