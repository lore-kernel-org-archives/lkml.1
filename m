Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbYGOS0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbYGOS0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbYGOS0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:26:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753025AbYGOS0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:26:39 -0400
Date: Tue, 15 Jul 2008 11:25:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: david@lang.hm, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <487CEA73.9000408@garzik.org>
Message-ID: <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org>
 <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141756361.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807141805300.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org> <487C585C.2060002@garzik.org>
 <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org> <487CD7FE.9010209@garzik.org> <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org> <487CDEC0.3090004@garzik.org> <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org>
 <487CEA73.9000408@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Jeff Garzik wrote:
> 
> Which is why 'make modules_install' installs the firmware, or at least it did
> before David W pushed upstream.

So you're literally just about making this be "make modules_install" 
rather than "make firmware_install"

Ok. Are you going to be happy if "make modules_install" just copies the 
firmware files of the affected modules too?

Or are you just whining because you want to whine, and will make up some 
new argument then?

			Linus
