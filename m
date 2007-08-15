Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbXHOPTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbXHOPTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 11:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761099AbXHOPTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 11:19:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760186AbXHOPTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 11:19:38 -0400
Date: Wed, 15 Aug 2007 11:19:33 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@codemonkey.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: two questions about the boot_delay
Message-ID: <20070815151933.GA13881@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Young <hidave.darkstar@gmail.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@codemonkey.org.uk>,
	LKML <linux-kernel@vger.kernel.org>
References: <a8e1da0708080039w1deed062hf5920e1257eb1cbb@mail.gmail.com> <20070811163331.b8ff4a6b.rdunlap@xenotime.net> <a8e1da0708150045i4b02e0a4u51a10084f1b439da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0708150045i4b02e0a4u51a10084f1b439da@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 03:45:08PM +0800, Dave Young wrote:
 > >On 8/12/07, Randy Dunlap <rdunlap@xenotime.net> wrote:
 > > On Wed, 8 Aug 2007 07:39:33 +0000 Dave Young wrote:
 > >
 > > > Hi,
 > > > I have tried the "slow down printk" , and I have two questions.
 > > >
 > > > 1. why it depends the DEBUG_KERNEL? Sometimes we only need boot_delay
 > > > to see the printk infomations.  How about set it as a standalone
 > > > config option?
 > >
 > > Is depending on DEBUG_KERNEL a problem?  If so, why?
 > 
 > IMHO, the DEBUG_KERNEL will build a big kernel and the building time
 > is long, so if the we only want to look at the boot messages at panic
 > point, the DEBUG_KERNEL is not needed.
 
Only if you enable other debug options too. (Yes, some default to on,
perhaps they shouldn't).

DEBUG_KERNEL itself shouldn't make any difference to the generated
code at all.

	Dave

-- 
http://www.codemonkey.org.uk
