Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbYABFaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbYABFaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 00:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYABFaC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 00:30:02 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:32820 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbYABFaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 00:30:00 -0500
Date: Tue, 1 Jan 2008 21:29:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] crash - module radio-sf16fmr2 and esp interfere
Message-Id: <20080101212945.fad9cae3.randy.dunlap@oracle.com>
In-Reply-To: <80670983@web.de>
References: <80670983@web.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jan 2008 01:19:33 +0100 devzero@web.de wrote:

> same with radio-sf16fmr2 and esp
> 
> after repeatedly modrpobe/modprobe -r  radio-sf16fmr2,  i can hang my system when loading esp afterwards
> 
> before loading esp, doing a "cat /proc/ioport" segfaults
> 
> this is with 2.6.24rc6 and also with 2.6.22
> 
> i have found these issues by running some (probably sick :D )  module load/unload test across all modules 
> 

Hi,
Please provide more kernel crash info, as listed in the
REPORTING-BUGS file in the top-level directory of the kernel
source tree.

Thanks.

> > -----Ursprüngliche Nachricht-----
> > Von: devzero@web.de
> > Gesendet: 01.01.08 21:46:30
> > An: linux-kernel@vger.kernel.org
> > Betreff: Re: [BUG] crash - module l440gx buggy ? interfere
> 
> > 
> > same/similar behaviour with 
> > 
> > l440gx and container
> > l440gx and acpiphp
> > 
> > after load of l440gx, container and acpiphp modules do also hang my system on load/unload.
> > 
> > maybe l440gx leaving the system in some weird state after probe ?
> > 
> > 
> > > -----Ursprüngliche Nachricht-----
> > > Von: <devzero@web.de>
> > > Gesendet: 01.01.08 20:57:08
> > > An: linux-kernel@vger.kernel.org
> > > Betreff: [BUG] crash - modules l440gx and parport_pc interfere
> > 
> > 
> > > 
> > > there seems some weird interference between l440gx and parport_pc modules
> > > 
> > > i can reproduceable crash my box by either:
> > > 
> > > modprobe parport_pc;modprobe l440gx;rmmod parport_pc
> > > 
> > > or
> > > 
> > > modprobe l440gx; modprobe parport_pc;rmmod parport_pc
> > > 
> > > this happens on 2.6.24rc6 and also older kernel (2.6.22)
> > > 
> > > nothing in dmesg - just 
> > > >JEDEC: Found no L440GX BIOS device at location zero
> > > >JEDEC probe on BIOS chip failed. Using ROM
> > > 
> > > because i haven`t appropriate hardware.
> > > 
> > > don`t know if this is a bug in parport_pc or l440gx but maybe its worth reporting.
> > > 
> > > regards
> > > roland


---
~Randy
desserts:  http://www.xenotime.net/linux/recipes/
