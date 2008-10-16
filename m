Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbYJPL5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbYJPL5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbYJPL5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:57:46 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:39573 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbYJPL5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:57:45 -0400
X-BigFish: VPS-15(zz1432R98dR4015M1805M936fOzzzz3198u327anz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K8TYJR-01-1VZ-01
Date: Thu, 16 Oct 2008 13:57:03 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix compile warning for !(ACPI && X86_IO_APIC)
	builds
Message-ID: <20081016115703.GH4706@alberich.amd.com>
References: <1223938850.21717.21.camel@odie.local> <20081014115307.GB29183@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20081014115307.GB29183@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Oct 2008 11:57:29.0202 (UTC) FILETIME=[5D2B6D20:01C92F86]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 01:53:07PM +0200, Andreas Herrmann wrote:
> On Tue, Oct 14, 2008 at 01:00:50AM +0200, Simon Holm Thøgersen wrote:
> > This fixes the following compile warning for !(ACPI && X86_IO_APIC) builds:
> > 
> > arch/x86/kernel/early-quirks.c:99: warning: 'ati_ixp4x0_rev' defined
> > but not used
> 
> Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> 

Ingo,

maybe it's best to just apply this patch

http://marc.info/?l=linux-kernel&m=122406442128207

It should also fix the compile warning.


Thanks,

Andreas


