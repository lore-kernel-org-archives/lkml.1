Return-Path: <linux-kernel-owner+w=401wt.eu-S932982AbXG3Imc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982AbXG3Imc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 04:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760740AbXG3ImV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 04:42:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40909 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760593AbXG3ImU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 04:42:20 -0400
Date: Mon, 30 Jul 2007 14:24:30 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Petko Manolov <petkan@nucleusys.com>
cc: Oliver Neukum <oliver@neukum.org>, linux-usb-devel@lists.sourceforge.net,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Greg Kroah-Hartman <greg@kroah.com>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Petko Manolov <petkan@users.sourceforge.net>
Subject: Re: [linux-usb-devel] [PATCH] USB Pegasus driver - avoid a potential
 NULL pointer dereference.
In-Reply-To: <Pine.LNX.4.64.0707301053020.3113@bender.nucleusys.com>
Message-ID: <alpine.LFD.0.999.0707301422160.13448@enigma.security.iitk.ac.in>
References: <200707290019.02591.jesper.juhl@gmail.com>
 <a781481a0707281637n5b123e4aib46c4e4b009b0018@mail.gmail.com>
 <9a8748490707281655u66e50bbfqba58687b579a85fe@mail.gmail.com>
 <200707291049.26619.oliver@neukum.org>
 <Pine.LNX.4.64.0707301053020.3113@bender.nucleusys.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Jul 2007, Petko Manolov wrote:

> On Sun, 29 Jul 2007, Oliver Neukum wrote:
> 
> > [...]
> > pegasus == NULL there would be a kernel bug. Silently ignoring
> > it, like the code now wants to do is bad. As the oops has never been
> > reported, I figure turning it into an explicit debugging test is overkill,
> > so removal seems to be the best option.
> 
> In the past urb->context was not guaranteed to be non-null for any
> asynchronous calls.  If this is not the case anymore then it should be removed
> from at least two more locations in the driver.
> 
> Attached you'll find the resulting patch.

Given Oliver's earlier comment, it looks okay to me. Thanks.
