Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYDZGKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYDZGKt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 02:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYDZGKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 02:10:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbYDZGKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 02:10:13 -0400
Date: Fri, 25 Apr 2008 23:10:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: alek.du@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] i2c: Add Intel SCH I2C SMBus support
Message-Id: <20080425231001.97cabebc.akpm@linux-foundation.org>
In-Reply-To: <20080423143212.36dba2ea@hyperion.delvare>
References: <20080422100420.3ee5f150@dxy.sh.intel.com>
	<20080423143212.36dba2ea@hyperion.delvare>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 23 Apr 2008 14:32:12 +0200 Jean Delvare <khali@linux-fr.org> wrote:
> Hi Alek,
> 
> On Tue, 22 Apr 2008 10:04:20 +0800, alek du wrote:
> > This patch adds Intel SCH chipsets (US15W, US15L, UL11L) i2c bus support.
> 
> What kind of machines are these?
> 
> > 
> > Signed-off-by: Alek Du <alek.du@intel.com>
> > ---
> >  drivers/i2c/busses/Kconfig   |    7 +
> >  drivers/i2c/busses/Makefile  |    1 +
> >  drivers/i2c/busses/i2c-sch.c |  419 ++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 427 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/i2c/busses/i2c-sch.c
> > (...)
> 
> MAINTAINERS says:
> 
> I2C SUBSYSTEM
> (...)
> L:	i2c@lm-sensors.org
> 
> So it would be great if you could send your patch there rather than on
> LKML.
> 

"as well as" would be better than "rather than", please.


I worry about the inclusion of apm_bios.h.  The driver is configured to be
available on all architectures but apm_bios.h is surely x86-specific (and
maybe mips).

But afaict the inclusion is not needed?
