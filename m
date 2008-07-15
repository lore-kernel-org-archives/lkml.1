Return-Path: <linux-kernel-owner+w=401wt.eu-S1761876AbYGOS6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761876AbYGOS6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbYGOS6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:58:43 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49372 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754957AbYGOS6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:58:42 -0400
Date: Tue, 15 Jul 2008 14:58:01 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
Message-ID: <20080715185801.GH8185@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
	linux-kernel@vger.kernel.org
References: <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org> <487C585C.2060002@garzik.org> <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org> <487CD7FE.9010209@garzik.org> <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org> <487CDEC0.3090004@garzik.org> <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org> <487CEA73.9000408@garzik.org> <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org> <487CF01E.6000208@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487CF01E.6000208@garzik.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 02:44:46PM -0400, Jeff Garzik wrote:
> All of the regressions examples I am citing are cured by  
> firmware-in-module, because they are all examples of problems that occur  
> when you remove the ability to reproduce the same functional pieces as  
> 2.6.26.

Jeff,

	I think you've said this before, but let me try to help you
cut to the chase.  You are willing to *implement*
firmware-in-the-module for request_firmware(), but you want a
commitment that David Woodhouse and Linus will accept such a patch
before you go off and write it.  Is that right?

	If so, may I suggest you start implementing, instead of
sending e-mails?  For all the time people have spent arguing about it,
maybe it could have been implemented already.

	Once it has been implemented, do you have any further
objections aka ideas about how request_firmware() could be improved?

					- Ted
					(who is hoping we can guide
					 this thread onto slightly more
					 productive avenues)



