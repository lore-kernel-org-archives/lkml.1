Return-Path: <linux-kernel-owner+w=401wt.eu-S1763411AbYGOV1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763411AbYGOV1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYGOV1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:27:38 -0400
Received: from mail.lang.hm ([64.81.33.126]:40509 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbYGOV1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:27:37 -0400
Date: Tue, 15 Jul 2008 14:27:59 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, Frans Pop <elendil@planet.nl>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0807151426021.16109@asgard.lang.hm>
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>  <487C0365.5030203@garzik.org>  <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
  <200807151757.10626.elendil@planet.nl>  <1216149637.27242.65.camel@violet.holtmann.net>  <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>  <1216150616.27455.377.camel@shinybook.infradead.org>  <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org>
 <1216151640.27242.90.camel@violet.holtmann.net> <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008, Linus Torvalds wrote:

> On Tue, 15 Jul 2008, Marcel Holtmann wrote:
>>
>> you don't have to. We extend udev once and then it will always work.
>
> Umm. The thing is, people running new kernels with old user land is not
> just supposed to work, it's _really_ supposed to work.
>
> It's what I do. Something that breaks that has to have damn good reasons
> to break it.
>
> So I do not disagree with Jeff on that point _at_all_. I'm in violent
> agreement with Jeff on the fact that we should not require system updates
> for the kernel to do the right thing.
>
> The thing I disagree with Jeff on is that he then seems to turn that into
> something very negative ("let's not separate the firmware at all").

he's not saying not to seperate the firmware at all, he's asking for the 
_option_ of compiling a kernel that doesn't have the firmware seperate 
from the modules.

a kernel compiled with this option would just drop-in to an older distro 
with zero impact. newer distros that have updated their userspace tools 
could compile with different options and have the firmware seperate.

David Lang
