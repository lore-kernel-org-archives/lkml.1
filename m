Return-Path: <linux-kernel-owner+w=401wt.eu-S1762006AbYGOTTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762006AbYGOTTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbYGOTTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:19:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755402AbYGOTTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:19:15 -0400
Date: Tue, 15 Jul 2008 12:18:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: david@lang.hm, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <487CF5E4.2070400@garzik.org>
Message-ID: <alpine.LFD.1.10.0807151216430.3351@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714165956.7fe2d4ee@infradead.org> <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm>
 <alpine.LFD.1.10.0807141756361.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807141805300.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org> <487C585C.2060002@garzik.org> <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org>
 <487CD7FE.9010209@garzik.org> <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org> <487CDEC0.3090004@garzik.org> <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org> <487CEA73.9000408@garzik.org> <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org>
 <487CF01E.6000208@garzik.org> <alpine.LFD.1.10.0807151153020.3351@woody.linux-foundation.org> <487CF5E4.2070400@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Jeff Garzik wrote:
> 
> But without firmware-in-module this would be akin to adding kernel module
> support in version 1.0.1, and forcing all distros to fix their stuff
> immediately in order to upgrade from version 1.0.0.

You're just making that up. The distro's can fix it long before they use 
the kernel. 

And the users we can just fix by making request_firmware() look up the 
files itself, if it doesn't already.

You're just making up your bogus arguments.

			Linus
