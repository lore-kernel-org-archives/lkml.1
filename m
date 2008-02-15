Return-Path: <linux-kernel-owner+w=401wt.eu-S1761643AbYBOIeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761643AbYBOIeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 03:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbYBOIdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 03:33:53 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:49596 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbYBOIdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 03:33:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b3X2hglQewoorM4GCaFMqhDwy9+xOxB/nkgHrGdPXDas23utJaPVPmtQc0IKymEWBqrjfSEq8tZY0wzKWITS2GAOrtIm7FW3blp5R5T7UYtVcdmi7ArKruPh05+yqzr/lS6IXTwX8WsBfMhm84FDX+jwNE9GcI5D3XgD4wluRBg=
Message-ID: <386072610802150033k4dc2faf1je119bf5516336ee9@mail.gmail.com>
Date: Fri, 15 Feb 2008 16:33:50 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: linux-next: first tree
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080215003537.8911ce35.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 9:35 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
>  I have created the first cut of the linux-next tree at
>  git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git.
>
>  Things to know about this tree:
>
>  It has two branches - master and stable.  Stable is currently just Linus'
>  tree and will never rebase.  Master will rebase on an almost daily basis
>  (maybe slower at the start).
>
>  The tree consists of subsystem git and quilt trees.  Currently, the quilt
>  trees are integrated by importing them into appropriately based git
>  branches and then merging those branches.  This has the advantage that
>  any conflict resolution will onlt have to happen once at the merge point
>  rather than, possibly, sevveral times during the series.  However, I am
>  considering just applying the quilt trees on top of the current tree
>  to get a result more like Linus' tree - we will see. The git trees are
>  obviously just merged.
>
>  Between each merge, the tree was built with both an allmodconfig for both
>  powerpc and x86_64.
>
>  The tree currently contains:
>         Greg's driver-core, pci and usb quilt series (in that order)
>         Alasdair Kergon's device-mapper quilt tree
>         Jiri Kosina's hid git tree
>         Jean Delvare's i2c quilt tree
>         Randy Dunlap's kernel-doc quilt tree
>         Haavard Skinnemoen's avr32 git tree
>
>  There was only one unresolved conflict which could have been caused
>  because I was not sure where to base the kernel-doc tree.
>
>  So, comments, please.
>
>  Also, more trees please ... :-)
>
Hi Stephen,

Could you please add Blackfin tree to the linux-next

 git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git
for-linus

Thanks a lot.

And do you have the blackfin cross-compile toolchain?

Regards,
-Bryan
