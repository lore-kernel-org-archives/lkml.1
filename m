Return-Path: <linux-kernel-owner+w=401wt.eu-S1759745AbYGORbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbYGORbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYGORay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:30:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59881 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbYGORay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:30:54 -0400
Message-ID: <487CDEC0.3090004@garzik.org>
Date: Tue, 15 Jul 2008 13:30:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: david@lang.hm, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141756361.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807141805300.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org> <487C585C.2060002@garzik.org> <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org> <487CD7FE.9010209@garzik.org> <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 15 Jul 2008, Jeff Garzik wrote:
>> I'm curious how that works, especially given that you have claimed the _exact
>> opposite_ in years past, by pointing out how firmware separation could mean
>> no-boot.
> 
> Umm. Firmware separation _could_ mean non-boot.
> 
> DavidW &co fixed it. You can now build it in.
> 
> You seem to ignore that things change, and _have_ changed.

Already addressed -- you and David seem to be ignoring the common case 
where you may update the driver but not the kernel, making that feature 
far less useful than it appears.

Inability to update the kernel image (vmlinuz) is the case with just 
about every enterprise distro out there, including ones to be based on 
 >= 2.6.27.

Driver disks and our own in-tree build-module-out-of-tree support are 
built precisely for this purpose:  to build a new driver against an 
existing kernel, because so often you cannot update the core vmlinuz image.

(rather, you _can_ update vmlinuz, but that would fail on the next 
automated update, so its not a realistic option)

	Jeff


