Return-Path: <linux-kernel-owner+w=401wt.eu-S1762624AbYGOTYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762624AbYGOTYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbYGOTY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:24:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752203AbYGOTY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:24:27 -0400
Date: Tue, 15 Jul 2008 12:23:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Theodore Tso <tytso@mit.edu>, david@lang.hm,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <alpine.LFD.1.10.0807151218460.3351@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807151220070.3351@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org> <487C585C.2060002@garzik.org> <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org> <487CD7FE.9010209@garzik.org> <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org>
 <487CDEC0.3090004@garzik.org> <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org> <487CEA73.9000408@garzik.org> <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org> <487CF01E.6000208@garzik.org> <20080715185801.GH8185@mit.edu>
 <487CF70C.1030309@garzik.org> <alpine.LFD.1.10.0807151218460.3351@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Linus Torvalds wrote:
> 
> Could you _please_ entertain at least thinking about that option?

.. and the reason I ask you to do that is quite frankly, you seem to want 
to just hide the thing under a rug - and _encouraging_ people to not even 
try to work with a new and more flexible model.

For example, there's nothing wrong with having people replace their 
firmware when they want to. Equally, there's nothing wrong in having 
distros put stable firmware into another package, so that you don't need 
to have <n> different versions of the firmware in <n> different kernel 
module directories just because you have <n> different versions of the 
module itself.

So why do you want to work so hard at not just encouraging people to get 
the firmware loaded dynamically from the filesystem?

		Linus
