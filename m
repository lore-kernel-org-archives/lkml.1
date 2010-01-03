Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172Ab0ACXAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab0ACXAf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 18:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159Ab0ACXAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 18:00:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:59757 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab0ACXAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 18:00:30 -0500
Date: Sun, 3 Jan 2010 15:03:00 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Christian Hofstaedtler <ch@zeha.at>, linux-kernel@vger.kernel.org,
       bruce.w.allan@intel.com
Subject: Re: Linux* is not supported on the Intel(R) Desktop Board DP55KG -
 Kernel still hangs upon reboot.
Message-ID: <20100103150300.170dedee@infradead.org>
In-Reply-To: <alpine.DEB.2.00.1001031637230.17894@p34.internal.lan>
References: <20100103202345.GA20015@percival.namespace.at>
	<alpine.DEB.2.00.1001031637230.17894@p34.internal.lan>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jan 2010 16:40:38 -0500 (EST)
Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> 
> 
> On Sun, 3 Jan 2010, Christian Hofstaedtler wrote:
> 
> > Hi,
> >
> > In regard to the DP55KG board having reboot [1] and HPET [2] issues,
> > have you seen any fixes (from Intel?) for these problems?
> >
> > I now own such a board and see the same stuff on a distro-patched
> > 2.6.31.6.
> >
> > Thanks,
> >  Christian
> >
> > [1] http://thread.gmane.org/gmane.linux.kernel/903161/
> > [2] http://thread.gmane.org/gmane.linux.kernel/913374
> >
> > -- 
> > christian hofstaedtler
> >
> 
> Hello Christian,
> 
> The work around for the reboot [1] issue is append this to your
> kernel boot options in lilo/grub:
> 
> reboot=a

btw this can be automated... just needs a DMI quirk.
someone needs to get dmidecode output and add it to the existing
table of reboot= quirks...



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
