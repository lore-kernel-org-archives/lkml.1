Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbZASMrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbZASMrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 07:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760072AbZASMqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 07:46:40 -0500
Received: from mail.memset.com ([89.200.136.113]:43528 "EHLO mail.memset.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760193AbZASMqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 07:46:38 -0500
Date: Mon, 19 Jan 2009 12:44:36 +0000
From: Nick Craig-Wood <nick@craig-wood.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: David Wagner <daw@cs.berkeley.edu>, linux-kernel@vger.kernel.org
Subject: Re: Checking module parameters
Message-ID: <20090119124436.GD1646@craig-wood.com>
References: <bVsVO-15X-19@gated-at.bofh.it> <20090119093814.BC18014CA88@irishsea.home.craig-wood.com> <497453B6.8090403@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497453B6.8090403@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 11:19:34AM +0100, Stefan Richter wrote:
> Nick Craig-Wood wrote:
> > David Wagner <daw@cs.berkeley.edu> wrote:
> >>  Is there a way to tell what options have been applied to a currently
> >>  loaded kernel module?
> >> 
> >>  I'm trying to force libata to use 1.5Gbps rather than 3Gbps,
> ...
> > I had to do this recently (under debian I ended up putting
> > "libata force=1.5Gbps" into /etc/modules)
> > 
> > You can check it is working by looking for something like this in the log
> > 
> > [    2.345058] ata1: FORCE: PHY spd limit set to 1.5Gbps
> > [    2.345058] ata1: SATA max UDMA/133 abar m2048@0xfb106000 port 0xfb106100 irq 218
> 
> There is also /sys/module/*/parameters/* which can be read and in some
> cases even be written.

It doesn't appear to show the force parameter.  From the same server
as above :-

$ more /sys/module/libata/parameters/* | cat
::::::::::::::
/sys/module/libata/parameters/acpi_gtf_filter
::::::::::::::
3
::::::::::::::
/sys/module/libata/parameters/allow_tpm
::::::::::::::
0
::::::::::::::
/sys/module/libata/parameters/ata_probe_timeout
::::::::::::::
7500
::::::::::::::
/sys/module/libata/parameters/atapi_dmadir
::::::::::::::
0
::::::::::::::
/sys/module/libata/parameters/atapi_enabled
::::::::::::::
1
::::::::::::::
/sys/module/libata/parameters/atapi_passthru16
::::::::::::::
1
::::::::::::::
/sys/module/libata/parameters/dma
::::::::::::::
7
::::::::::::::
/sys/module/libata/parameters/fua
::::::::::::::
0
::::::::::::::
/sys/module/libata/parameters/ignore_hpa
::::::::::::::
0
::::::::::::::
/sys/module/libata/parameters/noacpi
::::::::::::::
0

-- 
Nick Craig-Wood <nick@craig-wood.com> -- http://www.craig-wood.com/nick
