Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578AbYGOVZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbYGOVZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbYGOVYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:24:43 -0400
Received: from mail.lang.hm ([64.81.33.126]:48361 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756328AbYGOVYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:24:42 -0400
Date: Tue, 15 Jul 2008 14:24:58 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: David Woodhouse <dwmw2@infradead.org>
cc: Marcel Holtmann <marcel@holtmann.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from	in-kernel,
 use it in more drivers.
In-Reply-To: <1216152377.26991.10.camel@shinybook.infradead.org>
Message-ID: <alpine.DEB.1.10.0807151424020.16109@asgard.lang.hm>
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org>  <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm>  <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org>
  <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm>  <alpine.LFD.1.10.0807141756361.3017@woody.linux-foundation.org>  <alpine.DEB.1.10.0807141805300.14223@asgard.lang.hm>  <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org>  <487C585C.2060002@garzik.org>
  <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org>  <487CD7FE.9010209@garzik.org>  <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org>  <487CDEC0.3090004@garzik.org>  <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org>
  <487CEA73.9000408@garzik.org>  <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org>  <1216146651.27455.336.camel@shinybook.infradead.org>  <1216152021.27242.94.camel@violet.holtmann.net> <1216152377.26991.10.camel@shinybook.infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008, David Woodhouse wrote:

> On Tue, 2008-07-15 at 22:00 +0200, Marcel Holtmann wrote:
>> I really think we should use /lib/firmware/`uname -r`/. I do see the
>> point here that I don't wanna overwrite existing firmware from other
>> installed kernels. Especially if modules_install will install the
>> firmware files.
>>
>> So in case of non-Ubuntu distros we have to push a fix to udev, but that
>> is not a big deal. It should be a one-line change if I am not mistaken.
>
> My concern with that is that even though it's a one-line change, it's a
> one-line change which people don't already _have_. We really do need to
> remain compatible with existing setups.

when I read this I had to double check who the mail was from. this sounds 
like exactly the statement that Jeff has been making in his arguments to 
allow for the firmware-in-the-modules approach.

David Lang

