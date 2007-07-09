Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbXGIPJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbXGIPJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 11:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbXGIPJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 11:09:16 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:53131 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbXGIPJP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 11:09:15 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: Hibernation Redesign
Date: Mon, 9 Jul 2007 17:09:09 +0200
User-Agent: KMail/1.9.7
Cc: Pavel Machek <pavel@ucw.cz>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200707081737.21932.a1426z@gawab.com> <200707091602.27312.oliver@neukum.org> <87bqelwt4p.fsf@jbms.ath.cx>
In-Reply-To: <87bqelwt4p.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707091709.09912.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 9. Juli 2007 schrieb Jeremy Maitin-Shepard:
> Oliver Neukum <oliver@neukum.org> writes:
> 
> [snip]
> 
> > Hm, once the new kernel is booted, this decision is irrevocable, isn't it?
> > Is there any way to deal with errors by handing control back?
> 
> Returning to the old kernel can be done by telling drivers to set the
> hardware to the appropriate state, then copying the backed up memory
> back to the beginning of physical memory, and finally jumping to the old
> kernel.  It would be much like what is done to resume from hibernation.

If you can do that, why load a new kernel image?

	Regards
		Oliver

