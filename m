Return-Path: <linux-kernel-owner+w=401wt.eu-S933200AbXBWTmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200AbXBWTmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 14:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933201AbXBWTmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 14:42:47 -0500
Received: from khc.piap.pl ([195.187.100.11]:39400 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933200AbXBWTmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 14:42:46 -0500
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <m3hctfqjna.fsf@maximus.localdomain>
	<20070221224027.GK22464@csclub.uwaterloo.ca>
	<200702212355.25601.s0348365@sms.ed.ac.uk>
	<m3bqjnrntu.fsf@maximus.localdomain> <45DF0C29.2080201@xs4all.nl>
	<m3wt2869nd.fsf@maximus.localdomain> <45DF2F9E.20905@xs4all.nl>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 23 Feb 2007 20:42:43 +0100
In-Reply-To: <45DF2F9E.20905@xs4all.nl> (Udo van den Heuvel's message of "Fri, 23 Feb 2007 19:17:02 +0100")
Message-ID: <m3mz3464p8.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel <udovdh@xs4all.nl> writes:

> I have DN19 and DN20 now and it doesn't work.
> Only because the INT mapping on the riser is not right?

Yes. I assume DN20 works, only DN19 has problems.

> http://www.morex.com.tw/drawing/MAR122-J%20Drawing.pdf shows some IDSEL
> jumper with ADxx numbers. What could these be?
> Photo at http://www.morex.com.tw/products/imgproduct/100-1.jpg.
>
> Still DN's?

The second file shows some 28-pin IC but it's not a PCI-PCI bridge.
Jumpers marked AD20-31 are for selecting IDSEL - AD20 = DN9, AD31 is DN20
(DNx = ADx - 11).

Perhaps they could say how the INTs are wired. It's possible the IC
plays some role there. If the riser card is for specific motherboard(s)
only (and it must be) then they can read the IDSEL jumper position
with this IC and rotate INTs appropriately (thus it could work, with that
particular motherboard(s), in any IDSEL jumper position).
-- 
Krzysztof Halasa
