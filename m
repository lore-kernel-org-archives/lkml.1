Return-Path: <linux-kernel-owner+w=401wt.eu-S935054AbXHGQVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935054AbXHGQVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 12:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbXHGQU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 12:20:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47065 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988AbXHGQU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 12:20:57 -0400
Message-ID: <46B89BE7.8090903@garzik.org>
Date: Tue, 07 Aug 2007 12:20:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
References: <1186248703.3439.20.camel@localhost.localdomain>	 <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>	 <1186458941.6637.44.camel@localhost.localdomain>	 <alpine.LFD.0.999.0708062059030.5037@woody.linux-foundation.org> <1186497106.3414.24.camel@localhost.localdomain>
In-Reply-To: <1186497106.3414.24.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> I'm arguing that a too strict an interpretation of bugfix only post -rc1
> will damage feature stabilisation.  Please think carefully about this.
> If we go out in a released kernel with a problematic user space ABI, we
> end up being committed to it forever.


IMO you're going off on your own tangent.  Linus never singled out bsg 
(far from it, in fact, since bsg was not a major LOC contributor) or 
declared ABI-related fixes verboten.

I don't think anyone wants to release a userspace ABI with problems, 
since we all know that's basically locked in stone once its in a 
mainline release.

AFAICS his main complaint was he felt your push was a big honking huge 
change, late in the game, that included obvious non-fixes.  And it was. 
  lpfc was probably the biggest part of that, not bsg, and it's pretty 
clear such a big lpfc update should have gone in when the merge window 
was open.  The [non-lpfc] cleanups were also not -rc2 material.

	Jeff


