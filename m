Return-Path: <linux-kernel-owner+w=401wt.eu-S1762054AbYBLJge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762054AbYBLJge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 04:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbYBLJg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 04:36:26 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53880 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757700AbYBLJgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 04:36:25 -0500
Date: Tue, 12 Feb 2008 11:36:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>, tony.luck@intel.com,
       anton@samba.org, paulus@samba.org, rusty@rustcorp.com.au
Subject: Re: [BUID_FAILURE] regression from 2.6.24-git18 to 2.6.25-rc1-git1
	on section type conflict psmouse-base
Message-ID: <20080212093614.GF2959@cs181133002.pp.htv.fi>
References: <47B14D52.6050404@linux.vnet.ibm.com> <20080211235929.791f7afb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080211235929.791f7afb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 11:59:29PM -0800, Andrew Morton wrote:
> On Tue, 12 Feb 2008 13:10:02 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > This build failure is seen on the powerpc from the 2.6.24-git18 kernel and is still visible
> > in the 2.6.25-rc1-git1.
> > 
> > drivers/input/mouse/psmouse-base.c:44: error: __param_proto causes a section type conflict
> > drivers/input/mouse/psmouse-base.c:44: error: __param_proto causes a section type conflict
> > make[3]: *** [drivers/input/mouse/psmouse-base.o] Error 1
> > make[2]: *** [drivers/input/mouse] Error 2
> > make[1]: *** [drivers/input] Error 2
> > 
> > The patch http://lkml.org/lkml/2008/2/8/514 seems to have not taken into 2.6.25-rc1 and 
> > 2.6.25-rc1-git(s). Is there any new patch i am missing out.
> 
> I have it queued up, along with quite a few other things, but for the next
> couple of days I have logistical problems which are preventing me from
> doing runtime testing.

And this really isn't a regression.

It seems Kamalesh has upgraded his gcc to 4.2 between trying 
2.6.24-git18 and trying 2.6.25-rc1-git1?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

