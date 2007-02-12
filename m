Return-Path: <linux-kernel-owner+w=401wt.eu-S965360AbXBLT5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965360AbXBLT5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 14:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965359AbXBLT5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 14:57:36 -0500
Received: from mga06.intel.com ([134.134.136.21]:7747 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965360AbXBLT5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 14:57:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,316,1167638400"; 
   d="scan'208"; a="195884705:sNHT21142037"
Date: Mon, 12 Feb 2007 11:57:33 -0800
From: Valerie Henson <val_henson@linux.intel.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>, Dave Jones <davej@redhat.com>,
       Michael Kerrisk <mtk-manpages@gmx.net>, val_henson@linux.interl.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Documenting MS_RELATIME
Message-ID: <20070212195732.GC5108@nifty>
References: <45CE0737.6010103@gmx.net> <20070211005400.GC6849@redhat.com> <20070212065503.GC20919@nifty> <20070212154010.GC7617@redhat.com> <Pine.LNX.4.61.0702121848480.26360@yvahk01.tjqt.qr> <20070212195318.GB14369@elektroni.phys.tut.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212195318.GB14369@elektroni.phys.tut.fi>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 09:53:18PM +0200, Petri Kaukasoina wrote:
> On Mon, Feb 12, 2007 at 06:49:39PM +0100, Jan Engelhardt wrote:
> > >The one problem with noatime is that mutt's 'new mail arrived' breaks
> > 
> > Just why does not it use mtime then to check for New Mail Arrived, like 
> 
> I have always used:
> 
>   --enable-buffy-size        Use file size attribute instead of access time
> 
> Support was there at least in 1998, maybe before.

Good point.  However, this works for mutt because new mail is an
append-only operation.  Other apps don't have the guarantee that file
modifications that they care about will change the file size.

-VAL
