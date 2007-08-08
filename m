Return-Path: <linux-kernel-owner+w=401wt.eu-S1764901AbXHHMiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764901AbXHHMiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 08:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbXHHMiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 08:38:17 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:43514 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbXHHMiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 08:38:16 -0400
Date: Wed, 8 Aug 2007 08:37:29 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <ak@suse.de>
cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org
Subject: Re: [PATCH 18/25] [PATCH] turn priviled operations into macros in
 entry.S
In-Reply-To: <200708081424.49896.ak@suse.de>
Message-ID: <Pine.LNX.4.58.0708080835350.6751@gandalf.stny.rr.com>
References: <11865467522495-git-send-email-gcosta@redhat.com>
 <200708081138.23018.ak@suse.de> <Pine.LNX.4.58.0708080740490.5921@gandalf.stny.rr.com>
 <200708081424.49896.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 8 Aug 2007, Andi Kleen wrote:

>
> > Probably not, but this part of the code I don't fully understand.
>
> I would suggest to defer all this until at least one example to test it
> (except vsmp which is too simple) is around.

Who uses that code? NMIs and debug regs?  Lguest only has the host handle
the NMIs (doesn't pass to guest). And we haven't gotten to debug regs. Who
else uses that part of the code?

We can leave the "paranoid check" change out for this series.

-- Steve

