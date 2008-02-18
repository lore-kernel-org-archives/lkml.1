Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbYBRD1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbYBRD1W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 22:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbYBRD1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 22:27:13 -0500
Received: from hs-out-0708.google.com ([64.233.178.247]:8033 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbYBRD1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 22:27:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r2TONUovTfa8XXKEXNN3JvOtOJ8EzfasOMh6Ufp8yoj9f/PdXHY/j4yWlfOxY2zYQVXHLQN6MmHECU9Tiu43dqQYUYFqhBt/95PaKJgFMEo/DSag4/wjJw2uQyjPAgOCs0GTx7JLBYAFOl84b0KY4ug+A8cBZJVd7Cgu0h0ZYfs=
Message-ID: <804dabb00802171927r472fe558wfd44a5aa9da9381d@mail.gmail.com>
Date: Mon, 18 Feb 2008 11:27:08 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Sergio Luis" <sergio@larces.uece.br>
Subject: Re: What is "ERROR: "LGUEST_PAGES_guest_gdt_desc" [drivers/lguest/lg.ko] undefined!"
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <47B8DB7F.7070206@larces.uece.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47B786BF.8050703@gmail.com>
	 <20080216202740.74e22dbb.randy.dunlap@oracle.com>
	 <804dabb00802171638t30a4e754t53781a8f76fe5c22@mail.gmail.com>
	 <47B8DB7F.7070206@larces.uece.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/18/08, Sergio Luis <sergio@larces.uece.br> wrote:
> Peter Teoh wrote:
> > On 2/17/08, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >> On Sun, 17 Feb 2008 08:58:39 +0800 Peter Teoh wrote:
> >>
> >>> Can some explain the cause of this error (it has been like this for the
> >>> last two git pull from linus tree):
> >>>
> >>> Kernel: arch/x86/boot/bzImage is ready  (#1)
> >>>   Building modules, stage 2.
> >>>   MODPOST 1589 modules
> >>> ERROR: "LGUEST_PAGES_guest_gdt_desc" [drivers/lguest/lg.ko] undefined!
> >>> ERROR: "LGUEST_PAGES_host_gdt_desc" [drivers/lguest/lg.ko] undefined!
> >>> ERROR: "LGUEST_PAGES_host_cr3" [drivers/lguest/lg.ko] undefined!
> >>> ERROR: "LGUEST_PAGES_regs" [drivers/lguest/lg.ko] undefined!
> >>> ERROR: "LGUEST_PAGES_host_idt_desc" [drivers/lguest/lg.ko] undefined!
> >>> ERROR: "LGUEST_PAGES_guest_gdt" [drivers/lguest/lg.ko] undefined!
> >>> ERROR: "LGUEST_PAGES_host_sp" [drivers/lguest/lg.ko] undefined!
> >>> ERROR: "LGUEST_PAGES_regs_trapnum" [drivers/lguest/lg.ko] undefined!
> >>> ERROR: "LGUEST_PAGES_guest_idt_desc" [drivers/lguest/lg.ko] undefined!
> >>> WARNING: modpost: Found 14 section mismatch(es).
> >>> To see full details build your kernel with:
> >>> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> >>> make[1]: *** [__modpost] Error 1
> >>> make: *** [modules] Error 2
> >> Please try the patch at
> >> http://marc.info/?l=linux-kernel&m=120206956919303&w=2
> >> and report on its success/failure.  Thanks.
> >>
> >> ---
> >> ~Randy
> >>
> >
> > sorry for the delay....the problem still comes back after the patch...any ideas?
> >
> > THanks.
>
> you could test the patch I just posted at http://lkml.org/lkml/2008/2/17/388
> rusty's patch needs to be applied first.
> -sergio
>
> > --
Good, after the two patch applied the compilation was successful.
Thank you very much!!!
