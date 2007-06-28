Return-Path: <linux-kernel-owner+w=401wt.eu-S1765857AbXF1UYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765857AbXF1UYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 16:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762629AbXF1UX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 16:23:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37898 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764329AbXF1UX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 16:23:58 -0400
Date: Thu, 28 Jun 2007 13:23:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, John Keller <jpk@sgi.com>
Subject: Re: 2.6.22-rc6-mm1: io_apic build error
Message-Id: <20070628132343.2a15cc39.akpm@linux-foundation.org>
In-Reply-To: <20070628130921.bf43c8bb.randy.dunlap@oracle.com>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<20070628130921.bf43c8bb.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 13:09:21 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Thu, 28 Jun 2007 03:43:21 -0700 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/
> 
> 
> on x86_64, with CONFIG_PCI disabled, CONFIG_PM disabled,
> hence CONFIG_ACPI disabled:
> 
> 
> arch/x86_64/kernel/built-in.o: In function `setup_IO_APIC':
> (.init.text+0x4ef7): undefined reference to `mp_apic_pin_to_gsi'
> make: *** [.tmp_vmlinux1] Error 1
> 

hm, it's not immediately obvious how to fix that so I'll ask John to do
repairs, please. 
