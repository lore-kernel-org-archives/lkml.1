Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbXGDETH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbXGDETH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 00:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbXGDESz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 00:18:55 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47962 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbXGDESy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 00:18:54 -0400
Date: Tue, 3 Jul 2007 21:14:11 -0700
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Ni@m" <niam.niam@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: pci hidden behind transparent bridge
Message-ID: <20070704041411.GC27776@kroah.com>
References: <a9e22dff0707021209i13718d72p84160c4d3ff89e4@mail.gmail.com> <6bffcb0e0707030900k66defc1bi3ff8e70b23a050bf@mail.gmail.com> <20070703172506.GE18725@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070703172506.GE18725@redhat.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 01:25:06PM -0400, Dave Jones wrote:
> On Tue, Jul 03, 2007 at 06:00:14PM +0200, Michal Piotrowski wrote:
>  > Hi,
>  > 
>  > On 02/07/07, Ni@m <niam.niam@gmail.com> wrote:
>  > > Hi! I noticed such message:
>  > >
>  > > "PCI: Bus #07 (-#0a) is hidden behind transparent bridge #06 (-#06)
>  > > (try 'pci=assign-busses')
>  > > Please report the result to linux-kernel to fix this permanently"
>  > >
>  > > on my
>  > > Linux niam 2.6.22-rc6-cfs-v18 #6 Mon Jul 2 20:19:25 EEST 2007 i686
>  > > Intel(R) Celeron(R) M processor 1.50GHz GenuineIntel GNU/Linux
>  > >
>  > > What does it mean??
>  > 
>  > Is this a regressions?
> 
> There's about 8 gazillion of these reports that have been in bugzilla
> since the dinosaurs roamed the lands.   Just ripping the printk out
> would be my preference.

There is a patch in -mm and in my queue for 2.6.23 to revise the message
to send the information to the correct person responsible for it.

thanks,

greg k-h
