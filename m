Return-Path: <linux-kernel-owner+w=401wt.eu-S1761597AbXHTUOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761597AbXHTUOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756041AbXHTUOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:14:37 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:35892 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbXHTUOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:14:36 -0400
Date: Mon, 20 Aug 2007 21:13:44 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Message-ID: <20070820201344.GA13059@srcf.ucam.org>
References: <1186990219.22431.37.camel@caritas-dev.intel.com> <20070815161642.1bfbbe9c.akpm@linux-foundation.org> <46C38AA8.5040202@zytor.com> <1187251248.15063.12.camel@caritas-dev.intel.com> <m11wdzrwl7.fsf@ebiederm.dsl.xmission.com> <86802c440708191646r1caab5d8yd82c55fd2c8262db@mail.gmail.com> <46C9C9C7.8080506@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C9C9C7.8080506@zytor.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 10:05:11AM -0700, H. Peter Anvin wrote:
> Yinghai Lu wrote:
> > 
> > someone told me that EFI PEI will be 32 bit ( for mem etc
> > initialization), and after that will be 64 bit, so the Run time
> > service will be 64 bit only, and it will only support 64 bit OS with
> > EFI. and they have another mode to emulate the legacy BIOS to boot
> > 32bit OS.
> > 
> 
> That seems unlikely for e.g. the existing Macs already in the field.

In which direction? The existing Macs will boot a 32 (or 16) bit OS 
using legacy BIOS emulation. I've no idea if their EFI is 32 or 64 bit, 
though.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
