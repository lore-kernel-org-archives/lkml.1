Return-Path: <linux-kernel-owner+w=401wt.eu-S1762961AbYJJVXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762961AbYJJVXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759788AbYJJVXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:23:34 -0400
Received: from kroah.org ([198.145.64.141]:36239 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759310AbYJJVXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:23:33 -0400
Date: Fri, 10 Oct 2008 14:12:25 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Stefan Bader <stefan.bader@canonical.com>, stable@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH] x86: Reserve FIRST_DEVICE_VECTOR in
	used_vectors bitmap
Message-ID: <20081010211225.GA17695@kroah.com>
References: <48EFB4B2.2020508@canonical.com> <20081010201805.GC32164@kroah.com> <48EFBCA4.6020008@zytor.com> <20081010204133.GB32357@kroah.com> <20081010215038.13be501e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010215038.13be501e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 09:50:38PM +0100, Alan Cox wrote:
> On Fri, 10 Oct 2008 13:41:33 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Fri, Oct 10, 2008 at 01:35:48PM -0700, H. Peter Anvin wrote:
> > > Greg KH wrote:
> > >> Is there a problem with being assigned to IRQ0 in situations like this?
> > >
> > > On PCs, IRQ 0 is dedicated to use for the PIT.
> > 
> > Ah, I didn't realize it couldn't be shared.
> 
> And more importantly dev->irq == 0 or IRQ == 0 to anything but arch
> internal code means "no interrupt line".

I thought we had changed that a while ago, as some arches had 0 as a
valid irq line.

Anyway, thanks all for the information, I appreciate it.

greg k-h
