Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYCSTce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYCSTce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbYCST0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:26:25 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:21804 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319AbYCSTZQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:25:16 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47E12D39.2000207@goop.org>
References: <patchbomb.1205797011@localhost>
	 <1205918565.4112.61.camel@zakaz.uk.xensource.com>
	 <47E12D39.2000207@goop.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 19 Mar 2008 16:50:54 +0000
Message-Id: <1205945455.2489.18.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: 217.46.209.99
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-19 at 08:11 -0700, Jeremy Fitzhardinge wrote:
> Ian Campbell wrote:
> > On Mon, 2008-03-17 at 16:36 -0700, Jeremy Fitzhardinge wrote:
> >   
> >> Hi Ingo,
> >>
> >> This is a great big pile of x86 unification and Xen bugfix patches.
> >> They build and boot for me on 64-bit and 32-bit (PAE and non-PAE).
> >>     
> >
> > FWIW I tested in a PAE Xen guest on 32 and 64 bit h/v and it was fine
> > including running ddcprobe which was my most recent issue. I can't see
> > why this would fix it though.
> >   
> 
> I'm actually having problem booting 32-on-64 hvm guests.  Specifically 
> the Fedora installer crashes fairly early on:
[snip]
> 
> Seen anything like that?

I practically never boot HVM Linux guests of any sort so no.

> > I thought for a second when you said it booted on 64 bit you meant 64
> > bit Xen guest, do you know how that stuff ﻿is going?
> >   
> 
> Last I heard, they got something booting, but it wasn't very clean.  I 
> need to resync with Eduardo.  A lot of these changes were intended to 
> make that effort easier, but it would be nice to confirm ;)  Doesn't 
> look like http://git.et.redhat.com/?p=xen-pvops-64.git;a=summary has 
> changed much lately.

Thanks, will keep an eye on that tree.

> 
>     J
> 
-- 
Ian Campbell

Intel CPUs are not defective, they just act that way.
		-- Henry Spencer

