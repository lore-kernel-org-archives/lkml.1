Return-Path: <linux-kernel-owner+w=401wt.eu-S932240AbXCHGEC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbXCHGEC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 01:04:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932327AbXCHGEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 01:04:01 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34331 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932240AbXCHGEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 01:04:00 -0500
Date: Thu, 8 Mar 2007 11:31:39 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       pavel@suse.cz, rjw@sisk.pl
Subject: Re: [PATCH 1/20] x86_64: Assembly safe page.h and pgtable.h
Message-ID: <20070308060139.GJ6000@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070307065703.GA23412@in.ibm.com> <20070307065920.GB23412@in.ibm.com> <20070307192404.GA31826@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307192404.GA31826@uranus.ravnborg.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 08:24:04PM +0100, Sam Ravnborg wrote:
> On Wed, Mar 07, 2007 at 12:29:20PM +0530, Vivek Goyal wrote:
> > 
> > 
> > This patch makes pgtable.h and page.h safe to include
> > in assembly files like head.S.  Allowing us to use
> > symbolic constants instead of hard coded numbers when
> > refering to the page tables.
> > 
> > This patch copies asm-sparc64/const.h to asm-x86_64 to
> > get a definition of _AC() a very convinient macro that
> > allows us to force the type when we are compiling the
> > code in C and to drop all of the type information when
> > we are using the constant in assembly.
> Should this file not live in asm-generic and be useable
> for all architectures?
> 

Hi Sam,

Thanks for the review. This makes sense to me. Move const.h into
asm-generic and let everybody use it.

This is more of a small cleanup issue and involves changing few header files
in asm-sparc64 and make sure nothing is broken on sparc64. This patchset
is already becoming big and complex. Is it ok if we let the patch 
remain unmodified for now and once this gets in and settles down, I can
post another patch to do above modification?

Thanks
Vivek
