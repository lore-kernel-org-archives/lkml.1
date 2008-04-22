Return-Path: <linux-kernel-owner+w=401wt.eu-S1764576AbYDVOWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764576AbYDVOWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbYDVOWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:22:23 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:11400 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYDVOWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:22:22 -0400
X-IronPort-AV: E=Sophos;i="4.25,694,1199685600"; 
   d="scan'208";a="582498329"
Date: Tue, 22 Apr 2008 09:21:03 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: werner <werner@copaya.yi.org>, linux-kernel@vger.kernel.org,
       Tim Gardner <tim.gardner@canonical.com>
Subject: Re: EDD problem -- regression -- crash on booting by probing EDD
Message-ID: <20080422142103.GA5652@auslistsprd01.us.dell.com>
References: <1208730812.6879@copaya.yi.org> <20080422062840.195b4d3d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422062840.195b4d3d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 06:28:40AM -0700, Andrew Morton wrote:
> > On Sun, 20 Apr 2008 19:33:32 -0300 (GFT) "werner" <werner@copaya.yi.org> wrote:
> > There is a regression in 2.6.25.
> 
> Rafael bcc'ed.
> 
> >   Booting stops with: Probing EDD (edd=off to disable) message.
> > 
> > It dont work the kernel boot parameter edd=off .  With pci=off the computer continues to boot, but later it dont find hard disks etc.
> 
> Tim and Matt cc'ed.
> 
> > Thats happening on 2.6.25   definitive, but was verified to go back until 2.6.24-rc6-git8, but it wasnt yet at 2.6.24-rc6-git2 which worked correctly.
> > 
> 
> hm, that's a nice narrow window.  Unfortunately for the next few days I
> can't personally get in and find out what we changed during it.

I've scanned the diff between these, and can't see anything that would
obviously cause a problem.  Nothing that touches the EDD codepath
directly at least.  I'll be curious to see the additional initcall
debug data.

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
