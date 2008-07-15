Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbYGOFiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbYGOFiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 01:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbYGOFh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 01:37:58 -0400
Received: from mail.lang.hm ([64.81.33.126]:56587 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249AbYGOFh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 01:37:58 -0400
Date: Mon, 14 Jul 2008 22:37:58 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: David Woodhouse <dwmw2@infradead.org>
cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from	in-kernel,
 use it in more drivers.
In-Reply-To: <1216099930.27455.205.camel@shinybook.infradead.org>
Message-ID: <alpine.DEB.1.10.0807142236370.6370@asgard>
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>  <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> 
 <487C09EB.1050903@garzik.org>  <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org>  <487C1648.5070409@garzik.org>  <alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org>  <20080715050654.GH1369@1wt.eu>
 <1216099930.27455.205.camel@shinybook.infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, David Woodhouse wrote:

> On Tue, 2008-07-15 at 07:06 +0200, Willy Tarreau wrote:
>> This is just a matter of point of view. From my POV, having to feed
>> several unrelated files into a system to be able to get it to support
>> any device is moving backwards, compared to the currently clean
>> all-in-1 driver model.
>
> So you disapprove of having to load mac80211.ko before your wireless NIC
> driver? Or sungem_phy.ko before sungem.ko? Or libphy.ko before various
> other drivers?
>
> Or having to install /sbin/modprobe before you can load modules?

I actually have systems that don't have modprobe (Tivo series 1 boxes, 
they have the insmod/rmmod binary , but not modproble)
