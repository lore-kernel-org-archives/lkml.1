Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215Ab0ACXfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab0ACXfP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 18:35:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195Ab0ACXfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 18:35:12 -0500
Received: from percival.namespace.at ([77.244.242.130]:44248 "EHLO
	percival.namespace.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab0ACXfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 18:35:11 -0500
Date: Mon, 4 Jan 2010 00:34:57 +0100
From: Christian Hofstaedtler <ch@zeha.at>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       bruce.w.allan@intel.com
Subject: Re: Linux* is not supported on the Intel(R) Desktop Board DP55KG -
	Kernel still hangs upon reboot.
Message-ID: <20100103233456.GA4748@percival.namespace.at>
References: <20100103202345.GA20015@percival.namespace.at> <alpine.DEB.2.00.1001031637230.17894@p34.internal.lan> <20100103150300.170dedee@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100103150300.170dedee@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan,

* Arjan van de Ven <arjan@infradead.org> [100104 00:00]:
> On Sun, 3 Jan 2010 16:40:38 -0500 (EST)
> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> > On Sun, 3 Jan 2010, Christian Hofstaedtler wrote:
> > > Hi,
> > >
> > > In regard to the DP55KG board having reboot [1] and HPET [2] issues,
> > > have you seen any fixes (from Intel?) for these problems?
> > >
> > > I now own such a board and see the same stuff on a distro-patched
> > > 2.6.31.6.
> > >
> > > Thanks,
> > >  Christian
> > >
> > > [1] http://thread.gmane.org/gmane.linux.kernel/903161/
> > > [2] http://thread.gmane.org/gmane.linux.kernel/913374
> > >
> > 
> > Hello Christian,
> > 
> > The work around for the reboot [1] issue is append this to your
> > kernel boot options in lilo/grub:
> > 
> > reboot=a
> 
> btw this can be automated... just needs a DMI quirk.
> someone needs to get dmidecode output and add it to the existing
> table of reboot= quirks...

I guess it'd make more sense to fix it in the boards firmware, /if/ this is
possible. (I'm wondering what other OSes do in this regard.)

Here is the DMI data, anyway:

$ pwd
/sys/devices/virtual/dmi/id
$ cat board_name
DP55KG
$ cat board_vendor
Intel Corporation
$ cat board_version
AAE47218-403
$ cat product_name

$ cat sys_vendor

$ cat bios_date
10/28/2009
$ cat bios_vendor
Intel Corp.
$ cat bios_version
KGIBX10J.86A.3878.2009.1028.1049


I think I saw a patch for this floating around, but I'm not sure if this made
it into some branch.


  Christian

-- 
christian hofstaedtler
