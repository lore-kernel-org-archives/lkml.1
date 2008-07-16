Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbYGPEyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbYGPEyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 00:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbYGPEyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 00:54:45 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:35220 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbYGPEyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 00:54:44 -0400
Message-ID: <487D7F5C.9020503@keyaccess.nl>
Date: Wed, 16 Jul 2008 06:55:56 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from	in-kernel,
 use it in more drivers.
References: <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org> <487C585C.2060002@garzik.org> <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org> <487CD7FE.9010209@garzik.org> <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org> <487CDEC0.3090004@garzik.org> <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org> <487CEA73.9000408@garzik.org> <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org> <487CF01E.6000208@garzik.org> <20080715185801.GH8185@mit.edu> <487CF70C.1030309@garzik.org>
In-Reply-To: <487CF70C.1030309@garzik.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-07-08 21:14, Jeff Garzik wrote:

> Theodore Tso wrote:

>> If so, may I suggest you start implementing, instead of sending
>> e-mails?  For all the time people have spent arguing about it, 
>> maybe it could have been implemented already.
> 
> Already started, in fact, since Linus said he would not reject it out
> of hands.

Great, as I really hope this gets in. Was looking but am very scared of 
the linker goo...

I'm going to like the feature in itself once it has grown the ability 
for firmware in the module and really do not right now. One of the 
drivers I care about (old ISA SB16 CSP code) was also affected and my 
old 486 system with the hardware in it is _still_ lauging its little 
balls of at the people stating that "if you have userspace to load the 
module you have userspace to support at the hotplug/udev goo to load the 
firmware".

Given that one needs to be rather irrelevant to care about the SB16 CSP 
in the first place it wasn't enough to complain really, but yes, I'm 
really quite sure that I'm going to use the feature of building it into 
the module more than once while running around with floppies trying to 
support that old stuff.

Rene.
