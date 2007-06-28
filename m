Return-Path: <linux-kernel-owner+w=401wt.eu-S1764364AbXF1D6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764364AbXF1D6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 23:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763651AbXF1D56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 23:57:58 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53332 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759719AbXF1D55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 23:57:57 -0400
Date: Wed, 27 Jun 2007 21:57:54 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Adrian Bunk <bunk@stusta.de>, LKML Kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, david@lang.hm,
       linux-arch@vger.kernel.org
Subject: Re: Userspace compiler support of "long long"
Message-ID: <20070628035754.GB22063@parisc-linux.org>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de> <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm> <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de> <1182483527.10524.31.camel@shinybook.infradead.org> <20070622150038.GN23017@stusta.de> <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com> <20070627154046.GN1094@stusta.de> <468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de> <20070627173240.GR1094@stusta.de> <B3C8EEBF-71FB-4169-8ED7-7C4A410BBEE1@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B3C8EEBF-71FB-4169-8ED7-7C4A410BBEE1@mac.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 06:30:52PM -0400, Kyle Moffett wrote:
> Then all 64-bit archs have:
> typedef   signed long      __s64;
> typedef unsigned long      __u64;
> 
> While all 32-bit archs have:
> typedef   signed long long __s64;
> typedef unsigned long long __u64;

include/asm-parisc/types.h:typedef unsigned long long __u64;

For both 32 and 64-bit.

include/asm-sh64/types.h:typedef unsigned long long __u64;
include/asm-x86_64/types.h:typedef unsigned long long  __u64;

So that's three architectures that violate your first assertion.
