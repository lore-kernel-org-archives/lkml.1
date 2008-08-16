Return-Path: <linux-kernel-owner+w=401wt.eu-S1752957AbYHPP0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbYHPP0r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 11:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYHPP0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 11:26:38 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2643 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751765AbYHPP0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 11:26:38 -0400
Date: Sat, 16 Aug 2008 11:26:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Possible false positive in checkpatch
In-Reply-To: <48A5FBFD.5080501@zytor.com>
Message-ID: <Pine.LNX.4.44L0.0808161124220.14442-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008, H. Peter Anvin wrote:

> Alan Stern wrote:
> > The following appears to be a false positive in checkpatch:
> > 
> > ERROR: space prohibited after that '*' (ctx:BxW)
> > #163: FILE: drivers/usb/core/usb.c:304:
> > +#define usb_device_pm_ops      (* (struct pm_ops *) 0)
> >                                  ^
> > 
> > Certainly this is a rather uncommon code construction, but similar
> > ones might occur elsewhere.  To my eyes,
> > 
> > 	(* (type *) ptr)
> > 
> > looks better than
> > 
> > 	(*(type *) ptr)
> > 
> > or
> > 
> > 	(*(type *)ptr)
> > 
> > or even
> > 
> > 	(*(type*)ptr)
> > 
> > but of course this is a matter of opinion.  Is there any strong feeling 
> > about this in the kernel community?
> > 
> 
> Personally, I rather strongly prefer (*(type *)ptr).

It's probably safe to say that this is one of those gray areas where 
one need not adhere strictly to checkpatch's recommendations.

Alan Stern

