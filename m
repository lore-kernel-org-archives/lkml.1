Return-Path: <linux-kernel-owner+w=401wt.eu-S1423356AbXD3PRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423356AbXD3PRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423352AbXD3PRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:17:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423362AbXD3PRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:17:14 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/2] x86_64: Reflect the relocatability of the kernel in the ELF header.
Date: Mon, 30 Apr 2007 17:17:07 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Jurriaan <thunder7@xs4all.nl>,
       Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org,
       Horms <horms@verge.net.au>,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <m1slah6gm0.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1slah6gm0.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704301717.08230.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 April 2007 17:12:39 Eric W. Biederman wrote:
> 
> Currently because vmlinux does not reflect that the kernel is relocatable
> we still have to support CONFIG_PHYSICAL_START.  So this patch adds a small
> c program to do what we cannot do with a linker script set the elf header
> type to ET_DYN.
> 
> Since last time I have fixed the type to be in my code ET_DYN (oops),
> and verified this works with kexec.  I realized while testing that we
> don't have anyway of identifying a kernel vmlinux as linux so we
> probably want to add an ELF note but that will be another patch.

The patch is ok for me, but does it pass Vivek's usual testing?

-Andi
