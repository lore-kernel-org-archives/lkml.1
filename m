Return-Path: <linux-kernel-owner+w=401wt.eu-S1763577AbYGOV0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763577AbYGOV0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbYGOV0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:26:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306AbYGOV0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:26:09 -0400
Date: Tue, 15 Jul 2008 14:24:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Theodore Tso <tytso@mit.edu>, david@lang.hm,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <487D1327.7090805@garzik.org>
Message-ID: <alpine.LFD.1.10.0807151420550.2867@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org> <487C585C.2060002@garzik.org> <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org> <487CD7FE.9010209@garzik.org> <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org>
 <487CDEC0.3090004@garzik.org> <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org> <487CEA73.9000408@garzik.org> <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org> <487CF01E.6000208@garzik.org> <20080715185801.GH8185@mit.edu>
 <487CF70C.1030309@garzik.org> <alpine.LFD.1.10.0807151218460.3351@woody.linux-foundation.org> <487D1327.7090805@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Jeff Garzik wrote:
> 
> Kernel 2.6.26.  Older userland w/ initrd requirement, plus module w/
> compiled-in firmware.
> 
> Simply dropping 2.6.27 into that situation will produce an unbootable system,
> since the firmware would not get copied into the initrd.

Umm. Neither would the module.

So I assume you are doing the module load from the disk, not the initrd?

Or are you rebuilding the module into the initrd? If so, why didn't you do 
the firmware too and my "load directly from file" idea which is pretty 
simple? IOW, what's the fundamnetal problem here?

But hey, if you _do_ the "link it together", go ahead. I don't see why 
it's so magically superior, but I wanted it for the compiled-in driver 
case, so it's not fundamentally different from that either. And I can't 
really find the energy to care any more.

		Linus
