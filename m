Return-Path: <linux-kernel-owner+w=401wt.eu-S933735AbXIBAuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735AbXIBAuP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 20:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933269AbXIBAtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 20:49:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53021 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933067AbXIBAtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 20:49:49 -0400
Date: Sun, 2 Sep 2007 06:32:53 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Adrian Bunk <bunk@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH -mm] drivers/acpi/tables/tbutils.c: Shut up bogus
 uninitialized variable warning
In-Reply-To: <20070902001903.GC16016@stusta.de>
Message-ID: <alpine.LFD.0.999.0709020626340.20781@enigma.security.iitk.ac.in>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
 <alpine.LFD.0.999.0709020510300.20781@enigma.security.iitk.ac.in>
 <20070902001903.GC16016@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 2 Sep 2007, Adrian Bunk wrote:
> 
> On Sun, Sep 02, 2007 at 05:12:14AM +0530, Satyam Sharma wrote:
> > 
> > drivers/acpi/tables/tbutils.c: In function 'acpi_tb_parse_root_table':
> > drivers/acpi/tables/tbutils.c:403:
> > warning: 'rsdt_address' may be used uninitialized in this function
> > 
> > has been verified to be a bogus warning. Let's just initialize the
> > variable to zero and shut this up.
> >...
> 
> Please use uninitialized_var() instead.

On Sun, 2 Sep 2007, Satyam Sharma wrote:
> [...]
> I didn't use uninitialized_var() here because drivers/acpi/ is dual-licensed
> stuff and used elsewhere, where that macro may be unavailable (?)


Len, would it be okay to use uninitialized_var() in drivers/acpi/ code?
