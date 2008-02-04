Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbYBDXLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbYBDXLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYBDXLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:11:06 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60184 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754237AbYBDXLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:11:04 -0500
Date: Mon, 4 Feb 2008 15:10:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: linux-kernel@vger.kernel.org, "Russell Leidich" <rml@google.com>,
       Tim Hockin <thockin@hockin.org>
Subject: Re: 2.6.24-mm1 - build error, AMD MCE using Intel ifdef'd log
 function
Message-Id: <20080204151021.a116794f.akpm@linux-foundation.org>
In-Reply-To: <1202163830.6703.14.camel@localhost>
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
	<1202163830.6703.14.camel@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Feb 2008 15:23:50 -0700
Zan Lynx <zlynx@acm.org> wrote:

> 
> On Sun, 2008-02-03 at 17:16 -0800, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24/2.6.24-mm1/
> > 
> > 
> 
> arch/x86/kernel/built-in.o: In function `amd_smp_thermal_interrupt':
> (.text+0xe7c4): undefined reference to `mce_log_therm_throt_event'
> make: *** [.tmp_vmlinux1] Error 1
> 
> I looked in MAINTAINERS for MCE, MACHINE and CHECK, but didn't spot any
> likely entries to CC.

Thanks.  That'll be Russell's x86-amd-thermal-interrupt-support-fix-2.patch.

It looks like that patch is due for a serious overhaul so I think I'll just
drop the version whcih is in -mm, OK?

