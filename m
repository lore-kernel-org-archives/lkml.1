Return-Path: <linux-kernel-owner+w=401wt.eu-S933409AbXDCJB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409AbXDCJB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 05:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933567AbXDCJB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 05:01:59 -0400
Received: from build.arklinux.osuosl.org ([140.211.166.26]:39027 "EHLO
	mail.arklinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933409AbXDCJB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 05:01:58 -0400
From: Bernhard Rosenkraenzer <bero@arklinux.org>
To: Neil Brown <neilb@suse.de>
Subject: Re: 2.6.21-rc5-mm[12]: Oops on bootup in xor_see_2
Date: Tue, 3 Apr 2007 11:02:40 +0000
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dan Williams <dan.j.williams@intel.com>
References: <200703311736.47751.bero@arklinux.org> <20070331124049.ec87cb3a.akpm@linux-foundation.org> <17934.54983.192724.145829@notabene.brown>
In-Reply-To: <17934.54983.192724.145829@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704031102.40863.bero@arklinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 March 2007, Neil Brown wrote:
> > > Code: 44 89 74 24 48 0f 20 c6 0f 06 0f 11 04 24 0f 11 4c 24 10 0f 11 54
> > > 24 20 0f
> > >       11 5c 24 30 0f 18 82 00 01 00 00 0f 18 82 20 01 00 00 <00> 00 00
> > > 00 00 00
> > >       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > -
>
> Them bytes that look like '00' are mostly supposed to look like 'F0' -
> an x86 'noop'.
>
> Apparently a bin-utils bug.  An alpha of OpenSUSE-10.3 was compiling
> kernels like this.  I'm told it has been fixed.
>
> What distro/gcc version/binutils version was this compiled on?

You're right -- I'm using the current Ark Linux 2007.1 experimental build 
(always the latest stuff) - the update to binutils 2.17.50.0.13 broke it, 
after upgrading binutils to 2.17.50.0.14 everything is working perfectly 
again.

Thanks
bero
