Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbYGOUId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbYGOUId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYGOUI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:08:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbYGOUIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:08:25 -0400
Date: Tue, 15 Jul 2008 13:07:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Marcel Holtmann <marcel@holtmann.org>
cc: David Woodhouse <dwmw2@infradead.org>, Frans Pop <elendil@planet.nl>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <1216151640.27242.90.camel@violet.holtmann.net>
Message-ID: <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>  <487C0365.5030203@garzik.org>  <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
  <200807151757.10626.elendil@planet.nl>  <1216149637.27242.65.camel@violet.holtmann.net>  <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>  <1216150616.27455.377.camel@shinybook.infradead.org>  <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org>
 <1216151640.27242.90.camel@violet.holtmann.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Marcel Holtmann wrote:
> 
> you don't have to. We extend udev once and then it will always work.

Umm. The thing is, people running new kernels with old user land is not 
just supposed to work, it's _really_ supposed to work.

It's what I do. Something that breaks that has to have damn good reasons 
to break it.

So I do not disagree with Jeff on that point _at_all_. I'm in violent 
agreement with Jeff on the fact that we should not require system updates 
for the kernel to do the right thing.

The thing I disagree with Jeff on is that he then seems to turn that into 
something very negative ("let's not separate the firmware at all").

And I'd much rather just fix it. And that means that if people can point 
to udevd's that get confused - or lack of udevd's entirely - both of which 
sound very likely to me, then we should have a graceful fallback position.

And just supporting the notion of loading the firmware directly sounds 
like an obvious such case. It may not be the _only_ solution, for example, 
which is why I'd actually like to see people point to the _actual_ 
reported problems.

IOW, the problems shouldn't a "don't do this" thing. They should be a "ok, 
that problem happened, we can solve it by doing X".

			Linus
